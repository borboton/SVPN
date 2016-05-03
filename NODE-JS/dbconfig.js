module.exports = {
  user          : process.env.NODE_ORACLEDB_USER || "a000315",
  password      : process.env.NODE_ORACLEDB_PASSWORD || "a000315",
  connectString : process.env.NODE_ORACLEDB_CONNECTIONSTRING || "10.66.33.184/POVPNPR1DESA",
  externalAuth  : process.env.NODE_ORACLEDB_EXTERNALAUTH ? true : false
};
