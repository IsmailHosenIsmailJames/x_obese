String safeSubString(String s, int limit) {
  if (limit >= s.length) {
    return s;
  } else {
    return '${s.substring(0, limit)}...';
  }
}
