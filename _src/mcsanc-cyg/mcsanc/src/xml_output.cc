#include<iostream>
#include <string>
#include <cstring>
#include <sstream>
#include <vector>
#include <math.h>
#include <sys/times.h>
#include <tinyxml2.h>
#include "ShmHist.h"
#include "c_export.h"
extern "C" {
  void xml_write_(char* filename);
  int get_max_kin_cuts_();
  void get_process_name_(char *,int);
  void stop_clock_(double*, double*,double*);
}
extern  std::vector<ShmHist*> vshcum;


using namespace std;
using namespace tinyxml2;
static tinyxml2::XMLDocument doc;
namespace xml {

  XMLElement* add_node(XMLElement* parent, string node_name) {
    XMLElement* node = doc.NewElement(node_name.c_str());
    parent->InsertEndChild(node);
    return node;
  }

  template <typename T>
    XMLElement* add_text_node(XMLElement* parent, string tag, T text) {
      XMLElement* node = doc.NewElement(tag.c_str());
      stringstream ss;
      ss << text;
      XMLText* text_node=doc.NewText(ss.str().c_str());
      node->InsertEndChild(text_node);
      parent->InsertEndChild(node);
      return node;
    }

  XMLElement* init() {
//    XMLElement* versionNode = doc.NewElement("Version");
//    XMLText* versionText = doc.NewText("1.0.0");
//    versionNode->InsertEndChild(versionText);
    XMLDeclaration* declaration = doc.NewDeclaration();
    doc.InsertEndChild(declaration);
//    doc.InsertEndChild(versionNode);

    XMLElement* root= doc.NewElement("Document");
    doc.InsertEndChild(root);
    return root;
  }

  // convert fortran string to C++ string
  string sfix(char* fstr,int size) {
    char* cstr=(char*)alloca(sizeof(char)*size);
    memcpy(cstr,fstr,size);
    cstr[size-1]='\0';
    string cppstr=string(cstr);
    cppstr.erase(cppstr.find_last_not_of(" \n\r\t")+1);
    return cppstr;
  }

  void write(string filename) {
    doc.SaveFile(filename.c_str());
  }

}

using namespace xml;
void xml_write_(char* filename)
{
  XMLElement* cnode;
  XMLElement* root=init(); 

  //------------ Config
  XMLElement* config=add_node(root,"config");
  //------- input
  XMLElement* input=add_node(config,"input");
  XMLElement* process=add_node(input,"process");
  add_text_node(process,"sqs0",process_.sqs0);
  add_text_node(process,"processId",process_.processid);
  add_text_node(process,"irecomb",process_.irecomb);

//  XMLElement* beams=add_node(process,"beams");
  add_text_node(process,"beam",process_.beams[0]);
  add_text_node(process,"beam",process_.beams[1]);

  XMLElement* iflew=add_node(process,"iflew");
  add_text_node(iflew,"iqed",process_.iflew[0]);
  add_text_node(iflew,"iew",process_.iflew[1]);
  add_text_node(iflew,"iborn",process_.iflew[2]);
  add_text_node(iflew,"ifgg",process_.iflew[3]);
  add_text_node(iflew,"irun",process_.iflew[4]);
  add_text_node(iflew,"iph",process_.iflew[5]);

  add_text_node(process,"iflqcd",process_.iflqcd);
  add_text_node(process,"imsb",process_.imsb);
  add_text_node(process,"pdfmember",process_.pdfmember);
  add_text_node(process,"pdfset",sfix(process_.pdfset,256));
  add_text_node(process,"run_tag",sfix(process_.run_tag,256));

  XMLElement* vegas=add_node(input,"vegas");
  add_text_node(vegas,"relacc",comvegas_.relacc);
  add_text_node(vegas,"absacc",comvegas_.absacc);
  add_text_node(vegas,"flags",comvegas_.flags);
  add_text_node(vegas,"seed",comvegas_.seed);
  add_text_node(vegas,"maxeval",comvegas_.maxeval);
  add_text_node(vegas,"nstart",comvegas_.nstart);
  add_text_node(vegas,"nincrease",comvegas_.nincrease);
  add_text_node(vegas,"nexplore",comvegas_.nexplore);

  XMLElement* cuts=add_node(input,"KinCuts");
  XMLElement* cut;
  for(int i=0;i<get_max_kin_cuts_();i++) {
    if(!sfix(nml_cuts_.cutname[i],32).empty()) {
      cut=add_node(cuts,sfix(nml_cuts_.cutname[i],32));
      add_text_node(cut,"cutFlag",nml_cuts_.cutflag[i]);
      add_text_node(cut,"cutLow",nml_cuts_.cutlow[i]);
      add_text_node(cut,"cutUp",nml_cuts_.cutup[i]);
    }
  }

  // hists
//  XMLElement *hists=add_node(input, "histograms");
  XMLElement *fbh=add_node(input,"fbh");
  XMLElement *vbh=add_node(input,"vbh");
  XMLElement *hist_node;
  XMLElement *bins_node;
  ShmHist *hist;
  for(int ih=0; ih<vshcum.size(); ih++){
    hist=vshcum.at(ih);
    if(hist->get_hasVariableBins()) {
      hist_node=add_node(vbh,"histogram");
      add_text_node(hist_node,"name",hist->get_histName());
      add_text_node(hist_node,"flag",hist->get_flag());
      bins_node=add_node(hist_node,"bins");
      for(int ib=0; ib<= hist->get_nbins(); ib++) add_text_node(bins_node,"bin",hist->get_bins()[ib]);
    } else {
      hist_node=add_node(fbh,"histogram");
      add_text_node(hist_node,"name",hist->get_histName());
      add_text_node(hist_node,"flag",hist->get_flag());
      add_text_node(hist_node,"step",hist->get_step());
      add_text_node(hist_node,"xlow",hist->get_xlow());
      add_text_node(hist_node,"xup",hist->get_xup());
    }
  }

  // ----- ewparam
  XMLElement* ewparam=add_node(config,"ewparam");
  add_text_node(ewparam,"gfscheme",flags_.gfscheme);
  XMLElement* scales=add_node(ewparam,"scales");
  add_text_node(scales,"fscale",scales_.fscale);
  add_text_node(scales,"rscale",scales_.rscale);
  add_text_node(scales,"ome",scales_.ome);
  add_text_node(ewparam,"alpha",consts_.alpha);
  add_text_node(ewparam,"gf",consts_.gf);
  add_text_node(ewparam,"alphas",consts_.alphas);
  add_text_node(ewparam,"conhc",consts_.conhc);
  XMLElement* bmasses=add_node(ewparam,"boson_masses");
  add_text_node(bmasses,"mw",masses_.mw);
  add_text_node(bmasses,"mz",masses_.mz);
  add_text_node(bmasses,"mh",masses_.mh);
  add_text_node(bmasses,"ma",masses_.ma);
  add_text_node(bmasses,"mv",masses_.mv);
  XMLElement* widths=add_node(ewparam,"widths");
  add_text_node(widths,"wz",width_.wz);
  add_text_node(widths,"ww",width_.ww);
  add_text_node(widths,"wh",width_.wh);
  add_text_node(widths,"wtp",width_.wtp);
  XMLElement* ckm=add_node(ewparam,"ckm");
  add_text_node(ckm,"vud",sqrt(ckm_.vsq[6][3]));
  add_text_node(ckm,"vcs",sqrt(ckm_.vsq[2][9]));
  add_text_node(ckm,"vcd",sqrt(ckm_.vsq[4][9]));
  add_text_node(ckm,"vus",sqrt(ckm_.vsq[8][3]));
  add_text_node(ckm,"vub",sqrt(ckm_.vsq[0][7]));
  add_text_node(ckm,"vcb",sqrt(ckm_.vsq[0][9]));
  XMLElement* lepton_masses=add_node(ewparam,"lepton_masses");
  add_text_node(lepton_masses,"men",masses_.men);
  add_text_node(lepton_masses,"mel",masses_.mel);
  add_text_node(lepton_masses,"mmn",masses_.mmn);
  add_text_node(lepton_masses,"mmo",masses_.mmo);
  add_text_node(lepton_masses,"mtn",masses_.mtn);
  add_text_node(lepton_masses,"mta",masses_.mta);
  XMLElement* quark_masses=add_node(ewparam,"quark_masses");
  add_text_node(quark_masses,"mdn",masses_.mdn);
  add_text_node(quark_masses,"mup",masses_.mup);
  add_text_node(quark_masses,"mst",masses_.mst);
  add_text_node(quark_masses,"mch",masses_.mch);
  add_text_node(quark_masses,"mbt",masses_.mbt);
  add_text_node(quark_masses,"mtp",masses_.mtp);
  
  //---------- result
  XMLElement* result=add_node(root,"result");
  char process_name[128];
  get_process_name_(process_name,128);
  add_text_node(result,"process",process_name);
  // sigma
  XMLElement* sigmas=add_node(result,"sigma");
  XMLElement* sigma;
  int ncall_tot=0;
  double sig_tot=0, sige_tot=0;
  for(int is=0; is < stats_.nsig; is++) {
    sigma=add_node(sigmas,sfix(stats_.sig_name[is],32));
    add_text_node(sigma,"ncall",stats_.ncall[is]);
    add_text_node(sigma,"value",stats_.sig[is]);
    add_text_node(sigma,"error",stats_.sig_err[is]);

    ncall_tot = ncall_tot + stats_.ncall[is];
    sig_tot = sig_tot+stats_.sig[is];
    sige_tot = sige_tot+stats_.sig_err[is]*stats_.sig_err[is];
  }

  sige_tot = sqrt(sige_tot);
  sigma=add_node(sigmas,"total");
  add_text_node(sigma,"ncall",ncall_tot);
  add_text_node(sigma,"value",sig_tot);
  add_text_node(sigma,"error",sige_tot);

  // delta
  if(stats_.sig[0]!=0) {
    double delt  = (sig_tot/stats_.sig[0]-1)*100.;
    double delte = sqrt(pow(sige_tot/stats_.sig[0],2) 
        + pow(stats_.sig_err[0]*sig_tot/pow(stats_.sig[0],2),2))*100.0;
    XMLElement* delta_node=add_node(result,"delta");
    add_text_node(delta_node,"value",delt);
    add_text_node(delta_node,"error",delte);
  }

  //time 
  XMLElement* times_node=add_node(result,"time");
  double tot_time,sys_time,usr_time;
  stop_clock_(&tot_time,&sys_time,&usr_time);
  add_text_node(times_node,"total",tot_time/60.0);
  add_text_node(times_node,"user",usr_time/60.0);
  add_text_node(times_node,"system",sys_time/60.0);

  //hists 

//  hists=add_node(result, "histograms");
  XMLElement* bin_node;
  for(int ih=0; ih<vshcum.size(); ih++){
    hist=vshcum.at(ih);
    if(hist->get_flag()) {
      hist_node=add_node(result,"histogram");
      add_text_node(hist_node,"name",hist->get_histName());
//      bins_node=add_node(hist_node,"bins");
      for(int ib=0; ib< hist->get_nbins(); ib++) {
        bin_node=add_node(hist_node,"bin");
        add_text_node(bin_node,"start",hist->get_bins()[ib]);
        add_text_node(bin_node,"end",hist->get_bins()[ib+1]);
        if(hist->get_flag()&2) {
          double val=hist->get_vals()[ib];
          val/=(hist->get_bins()[ib+1] - hist->get_bins()[ib]);
          double err=hist->get_sigs()[ib];
          err/=(hist->get_bins()[ib+1] - hist->get_bins()[ib]);
          add_text_node(bin_node,"value",val); 
          add_text_node(bin_node,"error",err);
        } else {
          add_text_node(bin_node,"value",hist->get_vals()[ib]); 
          add_text_node(bin_node,"error",hist->get_sigs()[ib]);
        }
      }
    }
  }

  


  write(filename);
}
