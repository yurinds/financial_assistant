# financial_assistant

В этом приложении вы можете отслеживать все свои доходы и расходы за месяц.

## Пробная версия приложения доступна на [Heroku](https://fin-assistant.herokuapp.com)

логин: example_user@example.ru

пароль: 123456

---

## Для разворачивания приложения локально, требуется выполнить следующие шаги:

Требуемая версия Ruby и Rails:

```
ruby >= 2.6.3
rails ~> 5.2.3
```

Для запуска выполните в терминале следующие шаги:

1. Установите `Bundler`, если он ещё не установлен:

```
gem install bundler
```

2. Склонируйте репозиторий:

```
git clone https://github.com/yurinds/financial_assistant.git
# или
git clone git@github.com:yurinds/financial_assistant.git

# переход в папку с приложением
cd financial_assistant
```

3. Установите базу данных PostgreSQL

4. Сгенерируйте `master.key`

```
EDITOR=vim rails credentials:edit
```

5. В открывшейся области добавьте ключи:

```yaml
secret_key_base: ......
database:
  pg_dev_user: ваши значения
  pg_dev_pass: ваши значения
```

6. Установите все зависимости:

```
bundle install
```

7. Выполните миграции БД:

```
bundle exec rails db:migrate
```

7. Заполните базу тестовыми данными:

```
bundle exec rails db:seed
```

8. Запустите сервер приложения:

```
bundle exec rails s
```

9. Откройте в браузере:

```
http://localhost:3000
```
