setwd("C:/Users/yuwan vira/OneDrive/Dokumen/BIG DATA")
d <- read.csv("data_final_beneran.csv")
d <- d[complete.cases(d), ]

d$x1 <- d$hr
d$x2 <- d$sbp
d$x3 <- d$temp
d$y <- d$sepsis

d$x2_norm <- (d$x2 - min(d$x2)) / (max(d$x2) - min(d$x2))

d$f <- 0
for(i in 1:nrow(d)) {
  if(d$x3[i] > 38.0) {
    d$f[i] <- 1
  } else {
    d$f[i] <- 0
  }
}

mod <- glm(y ~ x1 + x2_norm + f, data = d, family = "binomial")
res <- predict(mod, type="response")

d$pred <- 0
for(i in 1:nrow(d)){
  if(res[i] > 0.65){
    d$pred[i] <- 1
  }
}
write.csv(d, "hasil.csv")