
#Structure de l'application

shinyUI(fluidPage(
  
  
  navbarPage("Breast Cancer",
             #Premier volet
             tabPanel("Introduction",
                      p("Le jeu de données que vous allez traiter est issu d'un traitement d'image effectué sur des noyaux de cellules de masses cellulaires mammaires, qui peuvent être considérées comme des tumeurs malignes ou bénines. Chaque noyau est décrit selon une liste de critères tels que le rayon du noyau cellulaire, son aire ou sa symétrie. Au total le nombre d'individus est de 569 et le nombre de critère évalué est de 30. Le but est de visualiser les données et de réussir à prédire la classe de la tumeur en fonction de ses caractéristiques.",style="font-size:20px;text-align:justify;color:black;background-color:PowderBlue;padding:15px;border-radius:10px"),
                      p(uiOutput("tab",style="font-size:15px;text-align:justify;color:black;background-color:PowderBlue;padding:20px;border-radius:10px"),
                        p("Vous allez pouvoir naviguer entre différents onglets qui vont vous permettre de: explorer les données, visualiser les données, d'accèder à un arbre et enfin de comparer différentes méthodes statistiques.",style="font-size:20px;text-align:justify;color:black;background-color:PowderBlue;padding:15px;border-radius:10px")
                      )),
             #Deuxième volet
             tabPanel("Exploration des données",
                      tabsetPanel(
                        tabPanel("Données",
                                 DT::dataTableOutput("table")),
                        tabPanel("Summary",
                                 verbatimTextOutput("summary")),
                        tabPanel("Matrtice de corrélation",
                                 plotOutput("cor"))
                        
                        
                      )),
                      #Troisième volet
                      tabPanel("Visualisation",
                               sidebarLayout(
                                 sidebarPanel(
                                   #Choix de la variable à afficher sur le boxplot
                                   selectInput("variable",
                                               "Variable",
                                               names(data)[-1])
                                   
                                 ),
                                 #Affichage du boxplot en fonction de la variable choisie
                                 mainPanel(
                                   plotOutput("plot"))
                                 
                               )
                      ),
                      #Quatrième volet
                      tabPanel("Arbres",
                               sidebarLayout(
                                 sidebarPanel(
                                   p("Cet arbre vous donne une sélection des variables qui permettent d'estimer au mieux la classe de la tumeur")
                                 ),
                                 mainPanel(
                                   plotOutput("plot2"))
                                 
                                 
                               )
                      ),
                      #Cinquième volet
                      tabPanel("Modeles de prediction",
                               sidebarLayout(
                                 sidebarPanel(
                                   radioButtons("modele",
                                                "Quel modele voules-vous appliquer aux donnees ?",
                                                #Choix du modèle à afficher
                                                choices = c("LDA",
                                                            "QDA",
                                                            "Multinomial",
                                                            "KNN")
                                   )
                                 ),
                                 mainPanel(
                                   p("Les modèles présentés ici sont construits à partir des mêmes jeu d'entraînement et de test. Il faut prendre en compte que les valeurs présentées ici sont amenées à varier si on appliquait plusieurs fois les modèles ou si on découpait les données d'une manière différente",style="font-size:20px;text-align:justify;color:black;background-color:PowderBlue;padding:15px;border-radius:10px"),
                                   dataTableOutput("radioModele"))
                               )
                      ),
                      #Sixième volet
                      tabPanel("Conclusion",
                               p("Ces différents onglets nous permettent de sélectionner le modèle qui nous semble le plus pertinent pour constituer un modèle de prédiction. Ce modèle nous permettra de détecter de manière visuelle si la tumeur détectée est maligne ou bénine",style="font-size:20px;text-align:justify;color:black;background-color:PowderBlue;padding:15px;border-radius:10px")
                      )
                      
                      
             )
  )
)
