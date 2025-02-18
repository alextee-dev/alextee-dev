
data "vault_generic_secret" "vault_example" {
  path = "secret/accounting"
}
output "vault_example" {
  value = nonsensitive(data.vault_generic_secret.vault_example.data).database_password #функция nonsensitive позволяет узнать значение sensitive данных
}

resource "vault_generic_secret" "example" {
  path = "secret/example"

  data_json = <<EOT
{
  "user1":   "pass1",
  "user2": "pass2",
  "test secret data": "congrats!"
}
EOT
}
#содержимое секретное. поглядеть можно через консоль

#> data.vault_generic_secret.vault_example # а содержимое data то скрыто!


#> nonsensitive(data.vault_generic_secret.vault_example.data) #вот так можно подсмотреть все ключи и значения

#> nonsensitive(data.vault_generic_secret.vault_example.data).1 а вот так сожно извлечь конкретный ключ

#Чем хорош vault ? Это версионирование для секретов.
