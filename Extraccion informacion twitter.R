######### Extraccion de tweets haciendo uso de la API de Twitter y del paquete Rtweet######

#Librerías requeridas

if (!require("pacman")) install.packages("pacman")
pacman::p_load(rtweet, dplyr, httpuv, stringr, writexl)


#¿Cómo autenticarse con la API de twitter?
vignette("auth", package = "rtweet")

# Almacenar llaves de la API (llave y llave secreta), LOS SIGUIENTES VALORES SON FALSOS
api_key <- "oaDassdJ4gdfgfdgkfghfghe3j"
api_secret_key <- "vuasethjq5jskwsajlDK9Dsdsdgffg734Ah368641zASDF3"

# Para autenticarse a través del navegador
token <- create_token(
  app = "TOPICS TEST",
  consumer_key = api_key,
  consumer_secret = api_secret_key)


# Extracción de tweets por año para el término de búsqueda 
# "oficina de transferencia de resultados de investigacion"
tweet_df_2020 <- search_fullarchive(
                   q="oficina de transferencia de resultados de investigacion", 
                   n=500, 
                   fromDate = 202001010000, 
                   toDate = 202010260000, 
                   env_name = "SEARCHTWEETS", 
                   token = token)

tweet_df_2019 <- search_fullarchive(
                   q="oficina de transferencia de resultados de investigacion", 
                   n=500, 
                   fromDate = 201901010000, 
                   toDate = 201912310000, 
                   env_name = "SEARCHTWEETS", 
                   token = token)

tweet_df_2018 <- search_fullarchive(
                   q="oficina de transferencia de resultados de investigacion", 
                   n=500, 
                   fromDate = 201801010000, 
                   toDate = 201812310000, 
                   env_name = "SEARCHTWEETS", 
                   token = token)

tweet_df_2017 <- search_fullarchive(
                   q="oficina de transferencia de resultados de investigacion", 
                   n=500, 
                   fromDate = 201701010000, 
                   toDate = 201712310000, 
                   env_name = "SEARCHTWEETS", 
                   token = token)

tweet_df_2016 <- search_fullarchive(
                   q="oficina de transferencia de resultados de investigacion", 
                   n=500, 
                   fromDate = 201601010000, 
                   toDate = 201612310000, 
                   env_name = "SEARCHTWEETS", 
                   token = token)

#Creación de bases de datos de tweets en archivos .xlsx para cada año

write_xlsx(tweet_df_2016,"G:\\RUTA DE ACCESO ELEGIDA\\Resultados API Twitter\\tweet_df_2016.xlsx")
write_xlsx(tweet_df_2017,"G:\\RUTA DE ACCESO ELEGIDA\\Resultados API Twitter\\tweet_df_2017.xlsx")
write_xlsx(tweet_df_2018,"G:\\RUTA DE ACCESO ELEGIDA\\Resultados API Twitter\\tweet_df_2018.xlsx")
write_xlsx(tweet_df_2019,"G:\\RUTA DE ACCESO ELEGIDA\\Resultados API Twitter\\tweet_df_2019.xlsx")
write_xlsx(tweet_df_2020,"G:\\RUTA DE ACCESO ELEGIDA\\Resultados API Twitter\\tweet_df_2020.xlsx")





