 
#include <cstdlib>
#include <iostream>
#include <map>
#include <string>
 
#include "TChain.h"
#include "TFile.h"
#include "TTree.h"
#include "TString.h"
#include "TObjString.h"
#include "TSystem.h"
#include "TROOT.h"
 
#include "TMVA/MethodCategory.h"
#include "TMVA/Factory.h"
#include "TMVA/DataLoader.h"
#include "TMVA/Tools.h"
#include "TMVA/TMVAGui.h"
 
 
void ClassificationCategory()
{
   //---------------------------------------------------------------
/// Example for usage of different event categories with classifiers
///the following method are implemented, both with and without categories
///                   - Fisher discriminats
///                   - Likelihoof
///                   - HMatrix
///
 //--------------------------------------------------------------------
   std::cout << std::endl << "==> Start TMVAClassificationCategory" << std::endl;
 
   // This loads the library
   TMVA::Tools::Instance();
 
   bool batchMode = false;
 
   // Create a new root output file.
   TString outfileName( "TMVACC.root" );
   TFile* outputFile = TFile::Open( outfileName, "RECREATE" );
 
   /// ##Create the factory object:
/// the possible transformation are Identity, Decorrelation, PCA, Gaussian followed by Decorrelation; progress bars are drawn to display training evaluation
    ///
/// - The first argument is the base of the name of all the output weight files in the directory weight/ that will be created with the method parameters
    ///
///- The second argument is the output file for the training results
 
/// - The third argument is a string option defining some general configuration for the TMVA session.
 
  std::string factoryOptions( "!V:!Silent:Transformations=I;D;P;G,D:!Correlations" );
  if (batchMode) factoryOptions += ":!Color:!DrawProgressBar";
 
   TMVA::Factory *factory = new TMVA::Factory( "TMVAClassificationCategory", outputFile, factoryOptions );
 
//-----------------------------------------------------------------------------------------
   /// ## Declare DataLoader
/// Define the input variables used for the MVA training: 'F' menas float, including both float and double type; 'I' is used for integers variables, including int, short, char
//-----------------------------------------------------------------------------------------
   TMVA::DataLoader *dataloader=new TMVA::DataLoader("dataset");
 
   dataloader->AddVariable( "var1", 'F' );
   dataloader->AddVariable( "var2", 'F' );
   dataloader->AddVariable( "var3", 'F' );
   dataloader->AddVariable( "var4", 'F' );
 
   // You can add so-called "Spectator variables", which are not used in the MVA training, but will appear in the final "TestTree" produced by TMVA. This TestTree will contain the input variables, the response values of all trained MVAs, and the spectator variables
   dataloader->AddSpectator( "eta" );
    
//-----------------------------------------------------------------------------------------
       /// ## Setup Dataset
    ///Load the signal and background event samples from ROOT trees
//-----------------------------------------------------------------------------------------
     
   TFile *input(0);
   TString fname = gSystem->GetDirName(__FILE__) + "/dati/";
   if (gSystem->AccessPathName( fname + "toy_sigbkg_categ_offset.root")) {
      // if directory data not found try using tutorials dir
      fname = gROOT->GetTutorialDir() + "/tmva/data/";
   }
    fname += "toy_sigbkg_categ_offset.root";
   if (!gSystem->AccessPathName( fname )) {
      // first we try to find tmva_example.root in the local directory
      std::cout << "--- TMVAClassificationCategory: Accessing " << fname << std::endl;
      input = TFile::Open( fname );
   }
 
   if (!input) {
      std::cout << "ERROR: could not open data file: " << fname << std::endl;
      exit(1);
   }
 
    //signal and background events are extracted from two different root trees from the input file
   TTree *signalTree     = (TTree*)input->Get("TreeS");
   TTree *background = (TTree*)input->Get("TreeB");
 
   // Global event weights per tree: individual event weights can also be applied
   Double_t signalWeight     = 1.0;
   Double_t backgroundWeight = 1.0;
 
   // Register the trees
   dataloader->AddSignalTree    ( signalTree,     signalWeight );
   dataloader->AddBackgroundTree( background, backgroundWeight );
 
   // Add sometihing if you want to apply additional cuts on signal and background events: this is useful in case signal and background events are located in the same tree
   TCut mycut_signal = "";
   TCut mycut_bkg = "";
    
//-------------------------------------------------------------------------------------
///-The input events that are handed to the factory are internally copied and split into one training asn one test root tgee
    ///
///-Tell numbers of events used in both samples are specified by the user: the default value is 0 and means that all events are used both for trainig and testinf
    ///
///-nTrain_Signal=8000 and nTest_Signal=0 means that the number of events to test is the total minus the number used to train (nTest_Signal=2000 in this case)
    ///
///-Add SplitSeed=100 if you want the same trainig and test sample each time TMVA runs
    
//-------------------------------------------------------------------------------------------
   dataloader->PrepareTrainingAndTestTree( mycut_signal, mycut_bkg,
                                        "nTrain_Signal=8000:nTrain_Background=8000:nTest_Signal=0:nTest_Background=0:SplitMode=Random:NormMode=NumEvents:!V:!CalcCorrelations" );
 //-------------------------------------------------------------------------------------------
/// ##Book MVA methods
///the first argument is a unique type enumerator, the second is a user-defined name and the third is the configuration option string
//---------------------------------------------------------------------------------------------
    
    // H-Matrix
    factory->BookMethod( dataloader, TMVA::Types::kHMatrix, "HMatrix", "H:!V:VarTransform=None:CreateMVAPdfs:");
    
   // Fisher discriminant
    factory->BookMethod( dataloader, TMVA::Types::kFisher, "Fisher", "H:!V:Fisher:VarTransform=None:CreateMVAPdfs:PDFInterpolMVAPdf=Spline2:NbinsMVAPdf=50:NsmoothMVAPdf=10");
 
   // Likelihood
   factory->BookMethod( dataloader, TMVA::Types::kLikelihood, "Likelihood",
                        "!H:!V:TransformOutput:CreateMVAPdfs:PDFInterpol=Spline2:NSmoothSig[0]=20:NSmoothBkg[0]=20:NSmoothBkg[1]=10:NSmooth=1:NAvEvtPerBin=50" );
 
//--------------------------------------------------------------------------------------------
   /// ##Categorised classifier
///splitting the data training into disjoint sub-populations having different properties according to the absolute value of the spectator variable eta
///adding a category:
    ///-the first argument is the cut that defines the category
    ///-the second defines the set of variables used to train the sub-classifier
    ///-the third is the enumerator of the sub-classifier
    ///-the fourth is the user-defined name
    ///the last is the string containing the options
//---------------------------------------------------------------------------------------------
    
   TMVA::MethodCategory* mcat = 0;
 
   // The variable sets
   TString theCat1Vars = "var1:var2:var3:var4";
    TString theCat2Vars = "var1:var2:var3:var4";
    
   // Fisher with categories
    //the category is booked taking as arguments the predefined enumerator, a user-defined identifier and a string containing the configuration options
   TMVA::MethodBase* fiCat = factory->BookMethod( dataloader, TMVA::Types::kCategory, "FisherCat","" );
    
    //the category is added
   mcat = dynamic_cast<TMVA::MethodCategory*>(fiCat);
   mcat->AddMethod( "abs(eta)<=1.3", theCat1Vars, TMVA::Types::kFisher, "Category_Fisher_1","!H:!V:Fisher" );
   mcat->AddMethod( "abs(eta)>1.3",  theCat2Vars, TMVA::Types::kFisher, "Category_Fisher_2","!H:!V:Fisher" );
 
   //Likelihood with categories
   TMVA::MethodBase* liCat = factory->BookMethod( dataloader, TMVA::Types::kCategory, "LikelihoodCat","" );
    
   mcat = dynamic_cast<TMVA::MethodCategory*>(liCat);
   mcat->AddMethod( "abs(eta)<=1.3",theCat1Vars, TMVA::Types::kLikelihood,
                    "Category_Likelihood_1","!H:!V:TransformOutput:PDFInterpol=Spline2:NSmoothSig[0]=20:NSmoothBkg[0]=20:NSmoothBkg[1]=10:NSmooth=1:NAvEvtPerBin=50" );
   mcat->AddMethod( "abs(eta)>1.3", theCat2Vars, TMVA::Types::kLikelihood,
                    "Category_Likelihood_2","!H:!V:TransformOutput:PDFInterpol=Spline2:NSmoothSig[0]=20:NSmoothBkg[0]=20:NSmoothBkg[1]=10:NSmooth=1:NAvEvtPerBin=50" );
 
    //H-Matrix with categories
    TMVA::MethodBase* HMatrixCat = factory->BookMethod( dataloader, TMVA::Types::kCategory, "HMatrixCat","" );
    
    mcat = dynamic_cast<TMVA::MethodCategory*>(HMatrixCat);
    mcat->AddMethod( "abs(eta)<=1.3", theCat1Vars, TMVA::Types::kHMatrix, "Category_HMatrix_1", "H:!V:VarTransform=None:CreateMVAPdfs:");
    mcat->AddMethod( "abs(eta)>1.3",  theCat2Vars, TMVA::Types::kHMatrix, "Category_HMatrix_2", "H:!V:VarTransform=None:CreateMVAPdfs:");

//-----------------------------------------------------------------------------------
    /// ## Test and Evaluate Methods
/// Now you can tell the factory to train, test, and evaluate the MVAs
//--------------------------------------------------------------------------------------
 
   // Train MVAs using the set of training events
   factory->TrainAllMethods();
 
   // Evaluate all MVAs using the set of test events
   factory->TestAllMethods();
 
   // Evaluate and compare performance of all configured MVAs
   factory->EvaluateAllMethods();
 
   // --------------------------------------------------------------
    // Access the factory and obtain the ROC curve
    auto c1 = factory->GetROCCurve(dataloader);
    c1->Draw();

    // Save the ROC curve to a PDF file
    TCanvas *canvas = c1->GetCanvas();
    canvas->SaveAs("ROC_curve.pdf");

   // Save the output
   outputFile->Close();
 
   std::cout << "==> Wrote root file: " << outputFile->GetName() << std::endl;
   std::cout << "==> TMVAClassificationCategory is done!" << std::endl;
    
    // Launch the GUI for the root macros
       if (!gROOT->IsBatch()) TMVA::TMVAGui( outfileName );
    
   // Clean up
   delete factory;
   delete dataloader;
 
   
}
