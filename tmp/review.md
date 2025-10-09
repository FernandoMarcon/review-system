Loaded cached credentials.
## Rare Variants

**Summary:**
A rare variant is a genetic alteration with a Minor Allele Frequency (MAF) of less than 0.5% in a population. While individually uncommon, they are collectively numerous and are thought to explain a significant portion of "Missing Heritability."

**Key Points:**
- Defined as a genetic variant with MAF < 0.5%.
- Collectively common, with every person having thousands.
- Their study is statistically challenging and requires large sample sizes.
- Specialized methods like Burden Tests and SKAT were developed to analyze them.

**Flashcards:**
Q: What is the typical Minor Allele Frequency (MAF) for a rare variant?
A: Less than 0.5%.

Q: What concept do rare variants help explain?
A: "Missing Heritability".

Q: What are two statistical methods developed for studying rare variants?
A: Burden Tests and Sequence Kernel Association Test (SKAT).

## Genomic Databases

**Summary:**
Genomic databases are structured collections of genetic variants used to estimate allele frequencies, which is critical for diagnosing Mendelian disorders. The diversity of these databases is crucial, as underrepresentation of certain ethnicities can lead to misinterpretation of variant pathogenicity.

**Key Points:**
- Provide variant allele frequency, which is clinically useful.
- Help identify if a rare variant is likely to cause a severe, high-penetrance disease.
- Ethnic bias (e.g., gnomAD being 77% European) hampers diagnostic accuracy for underrepresented populations.
- Diverse population data prevents mislabeling benign local variants as pathogenic.

**Flashcards:**
Q: What is the most clinically useful information derived from genomic databases for Mendelian disorders?
A: Variant allele frequency.

Q: Why is the ethnic diversity of a genomic database important?
A: It prevents mislabeling a variant that is common in one ethnicity as pathogenic because it is rare in another.

Q: What is a major limitation of the gnomAD v4 database?
A: 77% of the individuals represented are of European ancestry, underrepresenting most of the world's population.

## Gain-of-Function (GoF)

**Summary:**
Gain-of-function (GoF) variants are genetic alterations that result in gene products with enhanced activity, increased dosage, or even entirely new functions. They are typically inherited in an autosomal dominant manner and often involve specific missense changes or alterations in regulatory sequences.

**Key Points:**
- Result in gene products with enhanced or new activity.
- Can be caused by gene duplication, uncontrolled expression, or increased protein stability.
- Tend to cluster in specific sites within a gene.
- Usually inherited in an autosomal dominant pattern.

**Flashcards:**
Q: What is a gain-of-function (GoF) variant?
A: A variant that gives a gene product enhanced, new, or increased activity.

Q: How are GoF variants typically inherited?
A: In an autosomal dominant manner.

Q: What is a "gain-of-new-function" variant?
A: A dominant variant that results in a novel protein function, different from its original role.

## Genomic Variant Interpretation

**Summary:**
Genomic variant interpretation is the process of using multiple sources of evidence to determine if a genetic change is a disease-causing (pathogenic) variant. The process involves annotation, prioritization, and classification of the variant into one of five categories.

**Key Points:**
- The goal is to decide if a variant is clinically relevant and potentially disease-causing.
- It is standard practice to classify variants into five bins: Pathogenic, Likely Pathogenic, Uncertain Significance, Likely Benign, and Benign.
- The process involves three main steps: Variant annotation, variant prioritization, and variant classification.
- Publicly available datasets used for interpretation must be as complete and diverse as possible.

**Flashcards:**
Q: What is the main goal of genomic variant interpretation?
A: To decide if a genomic change could be disease-causing and clinically relevant.

Q: What are the five standard categories for variant classification?
A: Pathogenic, Likely Pathogenic, Variant of Uncertain Significance, Likely Benign, and Benign.

Q: What are the three major steps in the variant interpretation process?
A: Variant annotation, variant prioritization, and variant classification.

## ACMG/AMP Guidelines

**Summary:**
The ACMG/AMP guidelines provide a standardized framework for classifying genetic variants observed in patients with suspected inherited disorders. The system uses weighted evidence criteria to categorize variants into a five-tier system, but emphasizes that Variants of Uncertain Significance (VUS) should not be used for clinical decision-making.

**Key Points:**
- A framework for interpreting variants in suspected Mendelian disorders.
- Classifies variants as Pathogenic, Likely Pathogenic, VUS, Likely Benign, or Benign.
- Evidence for pathogenicity is weighted as very strong, strong, moderate, or supporting.
- Variants of Uncertain Significance (VUS) should not be used for clinical decision-making.

**Flashcards:**
Q: What organizations developed the main guidelines for variant classification?
A: The American College of Medical Genetics and Genomics (ACMG) and the Association for Molecular Pathology (AMP).

Q: What does it mean if a variant is classified as "likely pathogenic"?
A: There is a greater than 90% certainty that the variant is disease-causing.

Q: Should a Variant of Uncertain Significance (VUS) be used to make clinical decisions?
A: No.

## PLINK File Formats

**Summary:**
PLINK uses a set of three core files to efficiently store and manage genetic data: the `.fam` file for sample information, the `.bim` file as a map of genetic markers, and the `.bed` file which contains the actual genotype data in a compressed binary format.

**Key Points:**
- `.fam`: A text file with 6 columns describing each sample (ID, family, sex, phenotype).
- `.bim`: A text file with 6 columns that maps each variant to its genomic location.
- `.bed`: A binary file containing the genotype data in a highly compressed 2-bit format, which allows for fast processing.

**Flashcards:**
Q: What information is stored in the `.fam` file?
A: Sample information: Family ID, Individual ID, Paternal ID, Maternal ID, Sex, and Phenotype.

Q: What is the purpose of the `.bim` file?
A: It acts as a map, providing the chromosome, name, and base-pair position for each genetic variant.

Q: What are the two main advantages of the binary `.bed` file?
A: It has a much smaller file size and allows for significantly faster data processing.

## DeepVariant

**Summary:**
DeepVariant is a variant calling tool from Google that identifies SNPs and indels by treating the problem as an image recognition task. It converts sequencing data into "pileup images" and uses a Convolutional Neural Network (CNN) to classify sites as variant or non-variant with high accuracy.

**Key Points:**
- Uses a Convolutional Neural Network (CNN) for variant calling.
- Transforms aligned sequencing reads (BAM file) into image-like representations called pileup images.
- The CNN classifies each site's genotype (homozygous reference, heterozygous, or homozygous variant).
- The final output is a standard VCF file with high-confidence variant calls.

**Flashcards:**
Q: What type of AI model does DeepVariant use?
A: A Convolutional Neural Network (CNN).

Q: What is a "pileup image" in the context of DeepVariant?
A: A visual, multi-channel representation of all the sequencing read data at a specific genomic location.

Q: What are the primary input and output file formats for DeepVariant?
A: Input is a BAM file (aligned reads) and a FASTA file (reference genome); output is a VCF file (variant calls).

## RASP - het_check.py

**Summary:**
This Python script identifies and flags individual samples that are statistical outliers based on their heterozygosity rate. It calculates the rate for each sample from a PLINK `.het` file and removes those falling outside three standard deviations from the mean, as they may represent poor-quality or contaminated samples.

**Key Points:**
- Identifies outliers based on heterozygosity rate.
- Input is a `.het` file from PLINK.
- Calculates heterozygosity rate as `(N(NM) - O(HOM)) / N(NM)`.
- Flags individuals whose rate is more than 3 standard deviations from the mean.
- Output is a list of individuals to be removed in subsequent analyses.

**Flashcards:**
Q: What is the main purpose of the `het_check.py` script?
A: To identify and list outlier samples based on their heterozygosity rate for quality control.

Q: What statistical rule does the script use to identify outliers?
A: The 3-sigma rule (outliers are more than 3 standard deviations from the mean).

Q: What might a sample with an unusually high heterozygosity rate indicate?
A: Potential DNA sample contamination.

## RASP - Kinship_and_correction_0.1.py

**Summary:**
This Python script serves as a wrapper to manage two key confounding factors in genetic studies: linkage disequilibrium (LD) and population structure. It first uses PLINK to prune variants in high LD, then calls an R script to perform a sophisticated kinship analysis that corrects for population ancestry.

**Key Points:**
- Prunes variants for Linkage Disequilibrium (LD) using PLINK's `--indep-pairwise` command.
- Calls the `Kinship_tirando_PCAs_de_Estrututracao.R` script to perform the core analysis.
- The R script corrects kinship estimates for population structure using Principal Component Analysis (PCA).
- The final output is a list of individuals who are related up to a user-specified degree.

**Flashcards:**
Q: What two confounding factors does `Kinship_and_correction_0.1.py` aim to address?
A: Linkage disequilibrium (LD) and population structure.

Q: What tool does the script use to perform LD pruning?
A: PLINK.

Q: What is the final output of this script?
A: A text file listing pairs of related individuals (e.g., `Related_at_degree2.txt`).

## RASP - Kinship_tirando_PCAs_de_Estrututracao.R

**Summary:**
This R script accurately estimates genetic kinship while accounting for population structure by implementing a three-step methodology. It uses KING for an initial estimate, PC-AiR to generate ancestry-informative PCs from unrelated individuals, and finally PC-Relate to calculate corrected kinship coefficients using those PCs as covariates.

**Key Points:**
- Implements the KING, PC-AiR, and PC-Relate methodology.
- **KING:** Provides a robust initial kinship estimate.
- **PC-AiR:** Runs PCA on a partitioned "unrelated set" to avoid bias from family relationships.
- **PC-Relate:** Calculates final kinship coefficients, using the PCs from PC-AiR to correct for shared ancestry.

**Flashcards:**
Q: What is the main goal of the `Kinship_tirando_PCAs_de_Estrututracao.R` script?
A: To disentangle recent family relatedness from distant, shared ancestry in kinship estimates.

Q: What R package/algorithm is used to run PCA on a mix of related and unrelated samples?
A: PC-AiR (Principal Components Analysis in Related Samples).

Q: What algorithm calculates the final, ancestry-corrected kinship coefficients?
A: PC-Relate.

## RASP - apply_SKATO_v2.r

**Summary:**
This R script is the final analytical step in the RASP pipeline, performing powerful gene-based rare variant association tests. It builds a null model controlling for population structure (using PCs), then runs SKAT, Burden, and SKAT-O tests to see if the burden of rare variants in a gene is associated with the phenotype.

**Key Points:**
- Performs gene-based association tests for rare variants.
- Uses Principal Components (PCs) as covariates to control for population structure.
- Assigns higher weights to rarer variants to increase statistical power.
- Runs three tests: a Burden test, SKAT, and the optimal SKAT-O.
- The final output includes CSV files with corrected p-values and Manhattan plots for visualization.

**Flashcards:**
Q: What are the three main association tests run by this script?
A: The Burden test, SKAT, and SKAT-O.

Q: Why does the script include Principal Components (PCs) in its statistical model?
A: To control for confounding effects from population structure.

Q: What is the "optimal" and generally most powerful test performed by the script?
A: SKAT-O, because it adaptively combines the strengths of the Burden test and SKAT.

## PLINK --het file

**Summary:**
The `.het` file is generated by PLINK's `--het` command and provides detailed statistics on individual heterozygosity. It includes observed and expected homozygote counts, the number of non-missing genotypes, and a calculated inbreeding coefficient (F) for each sample.

**Key Points:**
- Output of the `plink --het` command.
- Contains columns for Observed (O(HOM)) and Expected (E(HOM)) homozygous counts.
- Includes the number of non-missing genotypes (N(NM)).
- Provides the inbreeding coefficient (F), where positive values suggest inbreeding and negative values can indicate contamination.

**Flashcards:**
Q: What PLINK command generates the `.het` file?
A: `plink --het`.

Q: What does the 'F' column in the `.het` file represent?
A: The inbreeding coefficient, calculated from observed and expected homozygosity.

Q: What might a negative F value suggest about a sample?
A: It has lower-than-expected homozygosity, which could indicate an outbred individual or DNA sample contamination.
