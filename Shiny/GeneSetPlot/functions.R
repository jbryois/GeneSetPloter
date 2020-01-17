# Code to plot gene sets

plot_gene_set <- function(d,gene_set,n){
    
    d <- d %>% gather(Lvl5,Expr_sum_mean_scaled10k,-Gene,-gene_id,-entrez_id)
    
    # Select column with matching names
    n_genes_symbol <- sum(gene_set[[1]]%in%d$Gene)
    n_genes_ensembl <- sum(gene_set[[1]]%in%d$gene_id)
    n_genes_entrez <- sum(gene_set[[1]]%in%d$entrez_id)
    
    gene_column <- which.max(c(n_genes_symbol,n_genes_ensembl,n_genes_entrez))
    gene_column_name <- colnames(d)[gene_column]
    
    p <- filter(d,(get(gene_column_name))%in%gene_set[[1]]) %>% 
        group_by(get(gene_column_name)) %>% 
        mutate(rank=rank(-Expr_sum_mean_scaled10k,ties.method="random")) %>% 
        filter(rank <=n) %>%
        ungroup() %>%
        #mutate(geneName=factor(geneName,levels=gene_set) %>%
        mutate(Lvl5=reorder_within(Lvl5,Expr_sum_mean_scaled10k,get(gene_column_name))) %>% 
        ggplot(.,aes(Lvl5,Expr_sum_mean_scaled10k,fill=Gene)) + geom_col() + 
        coord_flip() + 
        theme(legend.position = "none") + xlab("") + ylab("Expression (scaled 10k)") + 
        facet_wrap(~Gene,scales = "free",ncol=6) +
        scale_x_reordered() 
    return(p)
}

# Parse dataset name
parse_dataset_name <- function(dataset_path){
    name <- gsub("Data/","", dataset_path)
    name <- gsub(".1to1.norm.txt.gz","", name)
    name <- gsub(".norm.txt.gz","", name)
    name <- gsub(".all.norm.txt.gz","", name)
}
