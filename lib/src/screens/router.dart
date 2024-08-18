import 'package:boom_lotto/main.dart';
import 'package:boom_lotto/src/bloc/deposit/bloc/deposit_bloc.dart';
import 'package:boom_lotto/src/constants/strings.dart';
import 'package:boom_lotto/src/cubit/banner_cubit/todos_cubit.dart';
import 'package:boom_lotto/src/cubit/country_list_cubit/country_list_cubit.dart';
import 'package:boom_lotto/src/cubit/email_verification_cubit/email_otp_cubit.dart';
import 'package:boom_lotto/src/cubit/game_info_cubit/game_info_cubit.dart';
import 'package:boom_lotto/src/cubit/game_list_cubit/game_list_cubit.dart';
import 'package:boom_lotto/src/cubit/login_cubit/login_cubit.dart';
import 'package:boom_lotto/src/cubit/referral_code_cubit/referral_code_cubit.dart';
import 'package:boom_lotto/src/cubit/select_country_code_cubit/select_country_code_cubit.dart';
import 'package:boom_lotto/src/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:boom_lotto/src/cubit/transaction_list_cubit/transaction_list_cubit.dart';
import 'package:boom_lotto/src/cubit/withdrawal_cubit/verification_withdrawal_cubit/verification_withdrawal_cubit.dart';
import 'package:boom_lotto/src/cubit/withdrawal_cubit/withdrawal_cubit.dart';
import 'package:boom_lotto/src/data/model/country_list_model.dart';
import 'package:boom_lotto/src/data/network_service.dart';
import 'package:boom_lotto/src/data/repository.dart';
import 'package:boom_lotto/src/screens/country_list_screen.dart';
import 'package:boom_lotto/src/screens/deposit/deposit_screen.dart';
import 'package:boom_lotto/src/screens/game_screen.dart';
import 'package:boom_lotto/src/screens/home_screen.dart';
import 'package:boom_lotto/src/screens/login_screen.dart';
import 'package:boom_lotto/src/screens/otp_screen.dart';
import 'package:boom_lotto/src/screens/transaction_screen.dart';
import 'package:boom_lotto/src/screens/withdrawal/verification_withdrawal_screen.dart';
import 'package:boom_lotto/src/screens/withdrawal/withdrawal_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late Repository repository;
  late CountryListCubit countryListCubit;

  AppRouter() {
    repository = Repository(networkService: NetworkService());
    countryListCubit = CountryListCubit(repository: repository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case LOGIN_SCREEN:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) => countryListCubit,
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    LoginCubit(repository: repository),
              )
            ],
            child: const LoginScreen(),
          ),
        );
      case OTP_SCREEN:
        var data = settings.arguments as Map;
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) =>
                    SignUpCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    LoginCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    ReferralCodeCubit(repository: repository),
              )
            ],
            child: OtpScreen(
                number: data['mobileNumber'],
                type: data["type"],
                code: data['otpCode'],
                countryCode: data['countryCode'],
                countryName: data['countryName']),
          ),
        );
      case HOME_SCREEN:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) =>
                    TodosCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    GameInfoCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    GameListCubit(repository: repository),
              )
            ],
            child: const HomeScreen(),
          ),
        );
      case GAME_SCREEN:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) =>
                    TodosCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    GameInfoCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) =>
                    GameListCubit(repository: repository),
              )
            ],
            child: const GameScreen(),
          ),
        );

      case COUNTRY_LIST_SCREEN:
        final countryListModel = settings.arguments as CountryListModel;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => SelectCountryCodeCubit(
                    repository: repository,
                    countryListCubit: countryListCubit,
                  ),
                  child: CountryListScreen(countryListModel: countryListModel),
                ));

      case DEPOSIT_SCREEN:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (BuildContext context) => DepositBloc(),
            child: const DepositScreen(),
          ),
        );

      case TRANSACTIONS_SCREEN:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (BuildContext context) => TransactionListCubit(
                  repository: repository,
                ),
                child: TransactionScreen()));

      case WITHDRAWAL_SCREEN:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (BuildContext context) => WithdrawalCubit(repository: repository),
              ),
              BlocProvider(
                create: (BuildContext context) => EmailOtpCubit(repository: repository),
              )
            ], child: const WithdrawalScreen(),)
        );

      case VERIFICATION_WITHDRAWAL_SCREEN:
        final amount = settings.arguments.toString();
        return MaterialPageRoute(
            builder: (_) =>  MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (BuildContext context) => VerificationWithdrawalCubit(repository: repository),
                ),
              ],
              child: VerificationWithdrawalScreen(amount:amount),
            )
        );
      default:
        return null;
    }
  }
}
