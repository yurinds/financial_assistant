# financial_assistant

В этом приложении вы можете отслеживать все свои доходы и расходы за месяц.

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

3. Установите все зависимости:

```
bundle install
```

4. Выполните миграции БД:

```
bundle exec rails db:migrate
```

5. Запустите сервер приложения:

```
bundle exec rails s
```

6. Откройте в браузере:

```
http://localhost:3000
```
