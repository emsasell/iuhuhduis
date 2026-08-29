# FriendFind v2 — готовый деплой

Проект уже настроен. Вам нужно только:

## 1. Supabase
- Создайте проект.
- Откройте SQL Editor.
- Полностью выполните `supabase/schema.sql`.
- Authentication → Providers → Email: включите Email.
- Authentication → URL Configuration: добавьте адрес вашего сайта Vercel в Site URL и Redirect URLs.

## 2. Vercel — переменные окружения
Добавьте:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `SUPABASE_SERVICE_ROLE_KEY`

`SUPABASE_SERVICE_ROLE_KEY` доступен только серверным функциям и не попадает в браузер.

## 3. Деплой
Загрузите содержимое этого проекта в GitHub и импортируйте репозиторий в Vercel, либо выполните `vercel --prod`.

После этого сайт работает без редактирования файлов.

Владелец: `sunqwix@gmail.com` — при регистрации получает роль `owner` автоматически.
