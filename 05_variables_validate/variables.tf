variable "simple_string" {
  default = "ПЕРЕМЕННАЯ НЕ ЗАДАНА!!!"
  type        = string
  description = "любая строка"

  # ВАЛИДАЦИЯ: проверяем, что нет заглавных букв
  validation {
    # Условие: строка равна самой себе в нижнем регистре
    # Если есть хоть одна заглавная буква -> условие ЛОЖЬ -> ошибка
    condition = var.simple_string == lower(var.simple_string)
    
    # Сообщение, которое увидит пользователь при ошибке
    error_message = "ОШИБКА: в строке есть заглавные буквы! Используйте только маленькие буквы."
  }
}


# ПЕРЕМЕННАЯ 2: выбор между Коннором и Дунканом
variable "who_is_better" {
  description = "Кто круче: Коннор или Дункан?"
  
  type = object({
    Dunkan = optional(bool)
    Connor = optional(bool)
  })

  # Значение по умолчанию
  default = {
    Dunkan = true
    Connor = false
  }

  validation {
    # Проверяем, что значения РАЗНЫЕ (один true, другой false)
    condition = var.who_is_better.Dunkan != var.who_is_better.Connor
    error_message = "ОШИБКА: должен быть только один МакЛауд! (true/false или false/true)"
  }
}
