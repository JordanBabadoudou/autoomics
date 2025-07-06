library(Seurat)
library(ggplot2)

# 1. Charger les données Cell Ranger
seurat_data <- Read10X(data.dir = "sample/outs/filtered_feature_bc_matrix")
seurat_obj <- CreateSeuratObject(counts = seurat_data, project = "scRNA", min.cells = 3, min.features = 200)

# 2. Filtrage qualité
seurat_obj[["percent.mt"]] <- PercentageFeatureSet(seurat_obj, pattern = "^MT-")
seurat_obj <- subset(seurat_obj, subset = nFeature_RNA > 200 & nFeature_RNA < 2500 & percent.mt < 5)

# 3. Normalisation
seurat_obj <- NormalizeData(seurat_obj)
seurat_obj <- FindVariableFeatures(seurat_obj, selection.method = "vst", nfeatures = 2000)

# 4. PCA
seurat_obj <- ScaleData(seurat_obj)
seurat_obj <- RunPCA(seurat_obj)

# 5. Clustering
seurat_obj <- FindNeighbors(seurat_obj, dims = 1:10)
seurat_obj <- FindClusters(seurat_obj, resolution = 0.5)

# 6. UMAP
seurat_obj <- RunUMAP(seurat_obj, dims = 1:10)

# 7. Sauvegardes
p1 <- DimPlot(seurat_obj, reduction = "umap", label = TRUE) + ggtitle("Clusters UMAP")
ggsave("umap_clusters.png", plot = p1, width = 6, height = 5)

write.csv(Idents(seurat_obj), file = "seurat_clusters.csv")
saveRDS(seurat_obj, file = "seurat_object.rds")
