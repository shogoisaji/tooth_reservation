# create new user

-- ユーザー名を profiles テーブルにコピーする Database Function を定義
create or replace function public.handle_new_user() returns trigger as $$
begin
insert into public.profiles(id, user_name, phone_number)
values(new.id, new.raw_user_meta_data->>'user_name', new.raw_user_meta_data->>'phone_number');

        return new;
    end;

$$
language plpgsql security definer;

-- ユーザー作成時に`handle_new_user`を呼ぶためのトリガーを定義
create trigger on_auth_user_created
    after insert on auth.users
    for each row
    execute function handle_new_user();
$$

# profile RLS

-- RLS を有効にする
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- ポリシー 1: ユーザーは自分自身のプロフィールデータを更新できる
CREATE POLICY profiles_self_update ON public.profiles
FOR UPDATE
TO PUBLIC
USING (
auth.uid() = id
);

-- ポリシー 2: isAdmin が true のユーザーは任意のプロフィールデータを更新できる
CREATE POLICY profiles_admin_update ON public.profiles
FOR UPDATE
TO PUBLIC
USING (
EXISTS (
SELECT 1 FROM public.profiles
WHERE id = auth.uid() AND isAdmin = true
)
);

# reservation RLS

-- RLS を有効にする
ALTER TABLE public.reservation ENABLE ROW LEVEL SECURITY;

-- ポリシー 1: ユーザーは自分自身の予約データを更新できる
CREATE POLICY reservation_self_update ON public.reservation
FOR UPDATE
TO PUBLIC
USING (
auth.uid() = user_id
);

-- ポリシー 2: isAdmin が true のユーザーは任意の予約データを更新できる
CREATE POLICY reservation_admin_update ON public.reservation
FOR UPDATE
TO PUBLIC
USING (
EXISTS (
SELECT 1 FROM public.profiles
WHERE id = auth.uid() AND isAdmin = true
)
);
