#############Análisis contenido tweets extraidos de twitter##################

##Importación de paquetes
if (!require("pacman")) install.packages("pacman")
pacman::p_load(readxl, stringr, dplyr, ggplot2, lubridate, 
               tm, data.table, wordcloud, RColorBrewer,
               wordcloud2, readxl, writexl, SnowballC)

##Importación de datos

# Selección del directorio de trabajo. Listado de archivos con formato .xlsx
# dentro del directorio de trabajo

setwd("G:/directorio archivos xlsx/Resultados API Twitter")
file.list <- list.files(pattern='*.xlsx')
df.list <- lapply(file.list, read_excel)

# Creación de dataframes por cada archivo .xlsx del directorio

Tweets_2016_OTRI<-df.list[[1]]
Tweets_2017_OTRI<-df.list[[2]]
Tweets_2018_OTRI<-df.list[[3]]
Tweets_2019_OTRI<-df.list[[4]]
Tweets_2020_OTRI<-df.list[[5]]

#Combinación de todos los df en uno solo

df_tweets2016_2020 <- rbind(Tweets_2016_OTRI,
                            Tweets_2017_OTRI,
                            Tweets_2018_OTRI,
                            Tweets_2019_OTRI,
                            Tweets_2020_OTRI)

################## Análisis de los tweets ########################

#Gráfico de frecuencia  de tweets en el tiempo

plot_serie_twitter <- ts_plot(df_tweets2016_2020, 
        "months") + geom_line(color = "#21D39C", 
                              size = 1) + labs(
                                          title = "Evolución de la cantidad de tweets de la búsqueda: \n Oficina de transferencia de resultados de investigación",
                                          x = "Años",
                                          y = "Cantidad de Tweets") + theme(plot.title = element_text(hjust = 0.5))

#Guardado del gráfico generado 
ggsave("cantidad tweets publicados otri.pdf")

############ Creación de nube de palabras por frecuencia ###########

#Creación del objeto Vcorpus del paquete tm para el almacenamiento del contenido
#de todos los tweets recopilados
corp <- VCorpus(VectorSource(df_tweets2016_2020$text))

#Transformaciones del corpus de información para remover signos de puntuación,
#y palabras vacías

corp <- tm_map(corp, removePunctuation, ucp = TRUE)
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, removeWords, c("uso","ademá"))


#Generación de la matriz de términos del documento (Term Document Matrix)
#Donde se especifican las frecuencias por palabras del documento

twitter_opinions.tdm <- TermDocumentMatrix(corp, 
                                   control = 
                                     list(stopwords = TRUE,
                                          tolower = TRUE,
                                          stemming = TRUE,
                                          removeNumbers = TRUE,
                                          bounds = list(global = c(5, Inf)))) 

#Generación de un listado con los términos más frecuentes (aquellos que se repitan
# 10 o más veces)
ft <- findFreqTerms(twitter_opinions.tdm, 
                    lowfreq = 10, 
                    highfreq = Inf)


#Creación y organización del dataframe con las frecuencias totales entre 
#todos los documentos
prueba<-as.matrix(twitter_opinions.tdm[ft,])
prueba<-as.data.frame(prueba)

prueba$frec_total <- rowSums (prueba[ , 1:633])
setDT(prueba, keep.rownames = TRUE)[]
prueba<-prueba[,-c(2:634)]

#Organización y filtro de los resultados por frecuencia entre 20 y 200, ya que 
#las palabras por encima de 200 son aquellas que ya se sabe que estan 
#relacionadas con el tema de búsqueda

prueba<- prueba %>% arrange(desc(frec_total))
prueba<-subset(prueba,frec_total>20 & frec_total<200)

#Suma de filas con palabras similares (proceso manual)

#Este proceso se realiza para palabras que cuentan con sinónimos o con formas 
#mal escritas (Ej: excelente y excelene)
prueba[5,1]<-"colciencias"
prueba[62,1]<-"excelente"
prueba[19,2]<-prueba[19,2]+prueba[48,2] #Empresa

#Remoción de filas que son de palabras conectores o que no están relacionadas 
#con el área de estudio. Ej: hoy, info, cómo

remover<-c(6,7,8,9,11,20,23,35,37,38,40,42,44,45,48,50,54,55,56,59,60,61,64,65,68)
prueba<-prueba[-remover,]

#Reordenamiento del dataframe depurado
prueba<-subset(prueba,frec_total>20 & frec_total<110)

set.seed(1234)
#Nube de palabras formato 1. Palabras que se repitan mínimo 10 veces hasta 200
wordcloud(words = prueba$rn, freq = prueba$frec_total, min.freq = 10,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(15, "Paired"))

#Nube de palabras formato 2.
wordcloud2(data=prueba, size = 0.7, shape = 'cloud',color = brewer.pal(8,"Dark2"))

############ Cuentas de Twitter con mayor cantidad de publicaciones #############

#Creación del objeto Vcorpus del paquete tm para el almacenamiento de los nombres
#de las cuentas que más publican tweets asociados con el área de estudio
corp <- VCorpus(VectorSource(df_tweets2016_2020$screen_name))

#Transformaciones del corpus de información para remover signos de puntuación,
#y palabras vacías
corp <- tm_map(corp, removePunctuation, ucp = TRUE)
corp <- tm_map(corp, removeWords, stopwords("spanish"))
corp <- tm_map(corp, removeWords, c("uso","ademá"))

#Generación de la matriz de términos del documento (Term Document Matrix)
#Donde se especifican las frecuencias por palabras del documento
twitter_opinions.tdm <- TermDocumentMatrix(corp, 
                                           control = 
                                             list(stopwords = TRUE,
                                                  tolower = TRUE,
                                                  stemming = TRUE,
                                                  removeNumbers = TRUE,
                                                  bounds = list(global = c(1, Inf)))) 

#Generación de un listado con todos los nombres de cuenta (al menos una aparece una vez)
ft <- findFreqTerms(twitter_opinions.tdm, 
                    lowfreq = 1, 
                    highfreq = Inf)

#Creación y organización del dataframe con las frecuencias totales entre 
#todos los nombres
prueba<-as.matrix(twitter_opinions.tdm[ft,])
prueba<-as.data.frame(prueba)

prueba$frec_total <- rowSums (prueba[ , 1:633])
setDT(prueba, keep.rownames = TRUE)[]
prueba<-prueba[,-c(2:634)]

prueba<- prueba %>% arrange(desc(frec_total))
prueba<-subset(prueba,frec_total>20 & frec_total<200)


