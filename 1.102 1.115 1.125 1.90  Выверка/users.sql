select * from USERS t where
t.user_id in (select t.user_id from USERS_PRIV t
where priv_id = 90)
