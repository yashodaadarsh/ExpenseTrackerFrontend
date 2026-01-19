class ApiUrls {

  static final String ip_addr = '10.118.102.247';

  static final String baseUrl = 'http://$ip_addr:9898/';
  static final String registerUrl = '${baseUrl}auth/v1/signup';
  static final String loginUrl = '${baseUrl}auth/v1/login';
  static final String refreshTokenUrl = '${baseUrl}auth/v1/refreshToken';
  static final String accessTokenCheckUrl = '${baseUrl}auth/v1/ping';
  static final String healthCheckUrl = '${baseUrl}auth/v1/health';

  static final String dsBaseUrl = 'http://$ip_addr:8093/';
  static final String readMessageUrl = '${dsBaseUrl}v1/ds/message';

  static final String expenseBaseUrl = 'http://$ip_addr:9820';
  static final String getExpenseUrl = '${expenseBaseUrl}/expense/v1/getExpense';
  static final String addExpenseUrl = '${expenseBaseUrl}/expense/v1/addExpense';

  static final String userBaseUrl = 'http://$ip_addr:9810';
  static final String getUserUrl = '${userBaseUrl}/user/v1/getUser';
  static final String updateUserUrl = '${userBaseUrl}/user/v1/createUpdate';





}