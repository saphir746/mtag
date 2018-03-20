#chooseCRANmirror(graphics=FALSE, ind=53)

#source("https://bioconductor.org/biocLite.R")
#biocLite("biomaRt",suppressUpdates=FALSE,suppressAutoUpdate=FALSE,ask=F)

library(biomaRt)
library(data.table)

args = commandArgs(trailingOnly=TRUE)
filename = args[1]
outname = args[2]

df<-read.csv(filename)
snps<-df$snpid

#Mart used to map SNPs to Ensembl Gene IDs
grch37.snp = useMart(biomart="ENSEMBL_MART_SNP", host="grch37.ensembl.org", path="/biomart/martservice",dataset="hsapiens_snp")

#Mart used to map Ensembl Gene IDs to Gene name
grch37 = useMart(biomart="ENSEMBL_MART_ENSEMBL", host="grch37.ensembl.org", path="/biomart/martservice", dataset="hsapiens_gene_ensembl")

# Map snps to ensemble gene IDs
table1 <- getBM(attributes = c("refsnp_id", "ensembl_gene_stable_id"), 
                filters = "snp_filter", 
                values = snps, 
                mart = grch37.snp)

#Map ensemble gene IDs to genes names
table2 <- getBM(attributes = c("ensembl_gene_id", "external_gene_name","external_gene_source","variation_name","start_position","end_position","description"),
                filters = "ensembl_gene_id", 
                values =  table1$ensembl_gene_stable_id, 
                mart = grch37)

res <- merge(table1,table2, by.x = "ensembl_gene_stable_id", by.y="ensembl_gene_id", all.x=T)
names(res)[names(res) == "refsnp_id"] = "snpid"
res <-merge(res,df,by="snpid")

write.csv(res,file=outname,sep = "")
