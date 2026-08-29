# FriendFind v2 FIXED

## Нужно сделать только 2 вещи

### 1. Supabase
Откройте SQL Editor и выполните весь файл `supabase/schema.sql`.

В Authentication → Providers → Email включите Email.
В Authentication → URL Configuration добавьте URL вашего сайта Vercel в Redirect URLs.

### 2. Vercel → Settings → Environment Variables
Добавьте:
- `NEXT_PUBLIC_SUPABASE_URL` — Project URL из Supabase
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` — anon/public key из Supabase
- `SUPABASE_SERVICE_ROLE_KEY` — service_role key (только сервер)

После добавления переменных обязательно сделайте **Redeploy**.

## Важно
`public/config.js` больше заполнять не нужно. Сайт автоматически получает публичные Supabase-переменные через `/api/config`.

Владелец `sunqwix@gmail.com` автоматически получает роль owner при регистрации.
