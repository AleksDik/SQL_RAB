select u.* from USERS_PRIV t, users u
where priv_id = 109
and t.user_id=u.user_id
