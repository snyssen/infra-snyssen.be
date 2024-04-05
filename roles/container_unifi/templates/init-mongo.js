db.createUser({
  user: "unifi",
  pwd: "{{ unifi__mongo_pass }}",
  roles: [
    { role: "dbOwner", db: "unifi" },
    { role: "dbOwner", db: "unifi_stat" },
  ],
});
