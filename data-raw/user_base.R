## code to prepare `user_base` dataset goes here
# create_user_base.R

library(tibble)
library(sodium)

user_base <- tibble::tibble(
  user = c("koichi", "erwin"),
  password = c(
    sodium::password_store("wb1234"),
    sodium::password_store("wb1234")
  )
)

usethis::use_data(user_base, overwrite = TRUE)
