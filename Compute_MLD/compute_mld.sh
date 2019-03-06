#! /usr/bin/bash



############### Simulating 1000 sequences and computing the MLD
## Each simulation takes around 20 seconds, so 10000 runs should take several days
## This process can be easily paralellized
##



cd Simulating_sequences
rm mum_temp

for i in `seq 1 10000`;
do
	./simulate_evolving_seq K=1000 L=10000000 id=0 lambda=0.05 mu=1 t0=1.00000 t1=2.5
	mummer -maxmatch -b -n seq_A0_t1_2.50.fa seq_B0_t1_2.50.fa >>mum_temp
done

cd ..
./Compute_MLD/count_mummer.pl <Simulating_sequences/mum_temp


####################### Computing the MLD of Human and Mouse exomes
##

mummer -maxmatch -b -n exome_sequences/homo_sapiens_exome.fa exome_sequences/mus_musculus_exome.fa | ./count_mummer.pl -ortho_para 0 -out MLD/mld_human_mouse_exome.txt

####################### To compute the MLD of the full human and mouse genomes, one should:
#
# Downloads Repat masked genomes from the Ensembl website (or any other Genome database)
# Compute separately all pairwise chromosome comparison (all human chromosomes against all mouse chromosomes)
# Concatenate all mummer outputs in a single file and compute the MLD using ./Compute_MLD/count_mummer.pl
#
#
