#! /usr/bin/env nextflow

/*
Pipeline for the analyisis of prime-seq data
created by Oscar Infante
for the Epigenetics aging lab of Dr. David Valle Garcia.
*/
/*
Vamos a intentar primero hacer un codigo funcional y luego vamos a hacerlo bonito
El analisis normal de prime-seq es muy similar al de scRNA-seq, entonces vamos a usar mas o menos el mismo tipo de software
Limpieza y filtering
FastQC y trim_galore para ver la calidad, quitar adaptadores y volver a ver la calidad.
UMI-tools, para unificar los UMIs si hay una diferencia con scRNA-seq es aqui entonces con cuidado
STAR, para alinear a genoma, 
    hay que hacer un proceso para los indices? yo creo que si con un if o algo asi por si ya estan

UMI-tools dedup, para volver a quitar los duplicados por pcr, no estoy seguro de si con hacerlo previamente es suficiente
featureCounts, para sacar la matriz de cuentas
Creo que de momento esto es todo lo que necesitamos, ya posteriormente realizaremos los analisis de expresion diferencial

Vamos a utilizar docker de seqera labs para todos los programas o sus variantes
*/