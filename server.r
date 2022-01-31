
shinyServer(function(input, output) {
    #Lien vers la base de données sur Kaggle
    url = a("Kaggle Breast Cancer", href="https://www.kaggle.com/uciml/breast-cancer-wisconsin-data")
    output$tab <- renderUI({
        tagList("Lien pour la base de donnée:", url)
    })
    
    #Sortie de la table de données brute
    output$table <- DT::renderDataTable({
        data
    },style = "bootstrap")
    
    #Sortie des boxplots
    output$plot <- renderPlot({
        ggplot(data, aes(x = diagnosis, y = data[,input$variable])) + geom_boxplot(aes(fill = diagnosis)) +  scale_fill_manual(values = c("#28B463", "#F4D03F"))+ ylab(input$variable)
        
    },
    
    
    #Dimensionnement du graphique
    height = 600, width = 800
    )
    
    #Summary des données
    output$summary <- renderPrint({
        summary(data)
    })
    
    #Matrice de corrélation
    output$cor <- renderPlot({
        mcor = cor(data[,-1])
        corrplot(mcor, type="upper", order="hclust", tl.col="black", tl.srt=45)
    }
    )
    #Sortie pour l'arbre
    output$plot2 <- renderPlot({
        rpart(diagnosis~.,data=data)
        rpart.plot(rpart(diagnosis~.,data=data))
    })
    
    
    #Modèle réactif pour choisir le modèle à tester
    value_modele <- reactive(input$modele)
    
    output$radioModele <- DT::renderDataTable({
        
        # Modele de LDA
        if (value_modele() == "LDA") {
            mod.lda <- lda(diagnosis ~ .,data=data.train)
            pred.lda.test <- predict(mod.lda,newdata=data.test)$class
            
            erreur.lda <- get.error(data.test$diagnosis,pred.lda.test)
            specificite.lda <- get.specificity(data.test$diagnosis,pred.lda.test)
            sensibilite.lda <- get.sensitivity(data.test$diagnosis,pred.lda.test)
            LDA <- c(erreur.lda, specificite.lda, sensibilite.lda)
            
            resultats <- as.data.frame(cbind(Mesure,LDA))
            #print(resultats)
            
        } else {
            
            # Modele de QDA
            if (value_modele() == "QDA") {
                mod.qda <- qda(diagnosis ~ ., data=data.train)
                pred.qda.test <- predict(mod.qda, newdata=data.test)$class
                
                erreur.qda <- get.error(data.test$diagnosis,pred.qda.test)
                specificite.qda <- get.specificity(data.test$diagnosis, pred.qda.test)
                sensibilite.qda <- get.sensitivity(data.test$diagnosis, pred.qda.test)
                QDA <- c(erreur.qda, specificite.qda, sensibilite.qda)
                
                resultats <- as.data.frame(cbind(Mesure,QDA))
                #print(resultats)
                
            } else { 
                
                # Modele de regression mulinomiale
                if (value_modele() == "Multinomial") {
                    mod.multinom = multinom(diagnosis~.,data=data.train,maxit=200)
                    pred.multinom.test = predict(mod.multinom, newdata = data.test)
                    
                    erreur.multinom <- get.error(data.test$diagnosis,pred.multinom.test)
                    specificite.multinom <- get.specificity(data.test$diagnosis,pred.multinom.test)
                    sensibilite.multinom <- get.sensitivity(data.test$diagnosis,pred.multinom.test)
                    Multinomial <- c(erreur.multinom, specificite.multinom, sensibilite.multinom)
                    
                    resultats <- as.data.frame(cbind(Mesure,Multinomial))
                    #print(resultats)
                    
                } else {
                    
                    # Modele KNN
                    if (value_modele() == "KNN") {
                        mod.knn <- knn(train = data.train[,-1], cl=data.train$diagnosis, test=data.test[,-1], k=10) 
                        
                        erreur.knn <- get.error(data.test$diagnosis,mod.knn)
                        specificite.knn <- get.specificity(data.test$diagnosis,mod.knn)
                        sensibilite.knn <- get.sensitivity(data.test$diagnosis,mod.knn)
                        KNN <- c(erreur.knn, specificite.knn, sensibilite.knn)
                        
                        resultats <- as.data.frame(cbind(Mesure,KNN))
                        #print(resultats)
                    }
                }
            }
        }
        # Affichage du vecteur contenant les resultats
        resultats
    })
})