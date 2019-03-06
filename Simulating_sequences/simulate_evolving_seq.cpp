//
//  main.cpp
//  mutation-duplication
//
//  Created by Peter Arndt on 11/19/11.
//  Copyright 2011 Max Planck Institute for Molecular Genetics. All rights reserved.
//

#include <iostream>
#include "common.h"
#include "sequence.h"
#include "random.h"
#include "nr3.h"
#include "alphabet.h"


using namespace std;





void evolve_seq(sequence &s,double mu,int K,double dt, double lambda)
{
    Ran r(initrand());
    alphabet_index a(DNA);
    
    long L=s.length();
    double dtau=0.01;
    double t=0;
	double* vect_mu=NULL;  


	if (mu==0) {
		vect_mu = new double [L/K];
		for (int j=0; j<L/K;j++) {
			vect_mu[j]=1;
		}
	}
	else{
		vect_mu = new double [L/K];
		for (int j=0; j<L/K;j++) {
			vect_mu[j]=-mu*log(1-r.doub());
		}
	}

    while (t<dt){

        for (int i=0;i<L/K;i++){
			for(int j=i*K;j<(i+1)*K;j++) {
    		    if (r.doub()<lambda*dtau){
            	    int pos0=r.int64() % L;
            	    int pos1=r.int64() % L;
				
               		 for (int k=0;k<K;k++){
                   		 s[(pos1+k) % L]=s[(pos0+k) % L];
	           		}
				}
		        if (r.doub()<vect_mu[i]*dtau){
    	            int pos=j %L;
        	        int d=r.int64() % 3;
          	   		s[pos]=a.int_to_char((a.char_to_int(s[pos])+d+1)% 4);
				}
			}        	
        }

        t+=dtau;
    }

}


int main (const int argc,const char *argv[])
{
    StartUp(argc,argv);
    
    int L=10000000;
	GetValue("L",L);

	double mu=1,lambda=0.05;
	double t0=1,t1=2.5;
	int K=1000;
	int id=0;

	GetValue("mu",mu);
	GetValue("lambda",lambda);
	GetValue("K",K);
	GetValue("t0",t0);
	GetValue("t1",t1);
	GetValue("id",id);


    sequence s("ACGT");
    s.random_sample(L);
   	 
    evolve_seq(s, 0, K, t0, lambda);


	string data_dir="./";
	string ts=toa(t0,0);
	if (t0<1) ts=toa(t0,5);
	string fname=data_dir+"seq"+toa(id)+"_t"+ts+"_mu"+toa(mu,5)+"_ga"+toa(lambda,5)+"_K"+toa(K)+"_L"+toa(L)+".fa";

	fstream fout(fname.c_str(),ios::out);
	fout<<">s"<<endl<<s<<endl<<endl;
	fout.close();


    sequence r1("ACGT");
	r1=s;
    sequence r2("ACGT");
	r2=s;

    evolve_seq(r1,mu,K, t1, 0);
    evolve_seq(r2,mu,K, t1, 0);
	fname=data_dir+"seqA"+toa(id)+"_t1_"+toa(t1,2)+".fa";
	fout.open(fname.c_str(),ios::out);
	fout<<">r1"<<endl<<r1<<endl<<endl;
	fout.close();

	fname=data_dir+"seqB"+toa(id)+"_t1_"+toa(t1,2)+".fa";
	fout.open(fname.c_str(),ios::out);
	fout<<">r2"<<endl<<r2<<endl<<endl;
	fout.close();

    return 0;
}

