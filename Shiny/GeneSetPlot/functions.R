# Select column with matching names
select_column <- function(pathway,d){
    
    n_genes_symbol <- sum(pathway[[1]]%in%d$Gene)
    n_genes_ensembl <- sum(pathway[[1]]%in%d$gene_id)
    n_genes_entrez <- sum(pathway[[1]]%in%d$entrez_id)
    
    gene_column <- which.max(c(n_genes_symbol,n_genes_ensembl,n_genes_entrez))
    
    return(gene_column)
}

# Code to plot gene sets
plot_gene_set <- function(d,gene_set,n){
    
    d <- d %>% gather(Lvl5,Expr_sum_mean_scaled10k,-Gene,-gene_id,-entrez_id)
    
    # Select column with matching names
    gene_column <- select_column(gene_set,d)
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

# Heatmap
plot_heatmap <- function(d,pathway){
    d <- d %>% gather(Lvl5,Expr_sum_mean_scaled10k,-Gene,-gene_id,-entrez_id)
    
    gene_column <- select_column(pathway,d)
    gene_column_name <- colnames(d)[gene_column]
    
    d <- filter(d,get(gene_column_name)%in%pathway[[1]])
    
    d <- d %>% select(Gene,Lvl5,Expr_sum_mean_scaled10k) %>% spread(Lvl5,Expr_sum_mean_scaled10k) 
    
    genes <- d$Gene
    
    d <- select(d,-Gene) %>% t(.)
    colnames(d) <- genes
    
    if (nrow(d)<=50){
        return(pheatmap::pheatmap(d,scale = "column"))
    }
    if (nrow(d)>50 & nrow(d) <100){
        return(pheatmap::pheatmap(d,scale = "column",fontsize=5))
    }
    if (nrow(d)>=100){
        return(pheatmap::pheatmap(d,scale = "column",fontsize=3))
    }
}