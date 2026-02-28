# Переменная для одного IP-адреса
variable "ip_address" {
  type        = string
  description = "IP-адрес"

  validation {
    condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ip_address))
    error_message = "Значение должно быть корректным IPv4-адресом."
  }
}

# Альтернативный вариант валидации с использованием cidrhost()
variable "ip_address_cidr" {
  type        = string
  description = "IP-адрес (проверка через cidrhost)"

  validation {
    # Пробуем использовать IP как хост в сети /32
    condition = can(cidrhost("${var.ip_address_cidr}/32", 0))
    error_message = "Значение должно быть корректным IPv4-адресом."
  }
}

# Переменная для списка IP-адресов
variable "ip_addresses" {
  type        = list(string)
  description = "Список IP-адресов"

  validation {
    condition = alltrue([
      for ip in var.ip_addresses : can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip))
    ])
    error_message = "Все элементы списка должны быть корректными IPv4-адресами."
  }
}

# Альтернативный вариант для списка с использованием cidrhost()
variable "ip_addresses_cidr" {
  type        = list(string)
  description = "Список IP-адресов (проверка через cidrhost)"

  validation {
    condition = alltrue([
      for ip in var.ip_addresses_cidr : can(cidrhost("${ip}/32", 0))
    ])
    error_message = "Все элементы списка должны быть корректными IPv4-адресами."
  }
}
