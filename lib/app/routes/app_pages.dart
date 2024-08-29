import 'package:get/get.dart';

import '../modules/Admin/challenge_admin/bindings/challenge_admin_binding.dart';
import '../modules/Admin/challenge_admin/views/challenge_admin_view.dart';
import '../modules/Admin/editArticleAdmin/bindings/edit_article_admin_binding.dart';
import '../modules/Admin/editArticleAdmin/views/edit_article_admin_view.dart';
import '../modules/Admin/editChallengeAdmin/bindings/edit_challenge_admin_binding.dart';
import '../modules/Admin/editChallengeAdmin/views/edit_challenge_admin_view.dart';
import '../modules/Admin/editQuizAdmin/bindings/edit_quiz_admin_binding.dart';
import '../modules/Admin/editQuizAdmin/views/list_quiz_admin_view.dart';
import '../modules/Admin/editVideoAdmin/bindings/edit_video_admin_binding.dart';
import '../modules/Admin/editVideoAdmin/views/edit_video_admin_view.dart';
import '../modules/Admin/educationAdmin/bindings/education_admin_binding.dart';
import '../modules/Admin/educationAdmin/views/education_admin_view.dart';
import '../modules/Admin/homepageAdmin/bindings/homepage_admin_binding.dart';
import '../modules/Admin/homepageAdmin/views/homepage_admin_view.dart';
import '../modules/Admin/navigationAdmin/bindings/navigation_admin_binding.dart';
import '../modules/Admin/navigationAdmin/views/navigation_admin_view.dart';
import '../modules/Admin/profileAdmin/bindings/profile_admin_binding.dart';
import '../modules/Admin/profileAdmin/views/profile_admin_view.dart';
import '../modules/Admin/quizAdmin/bindings/quiz_admin_binding.dart';
import '../modules/Admin/quizAdmin/views/quiz_admin_view.dart';
import '../modules/Auth/login/bindings/login_binding.dart';
import '../modules/Auth/login/views/login_view.dart';
import '../modules/Auth/register/bindings/register_binding.dart';
import '../modules/Auth/register/views/register_view.dart';
import '../modules/Auth/resetPassword/bindings/reset_password_binding.dart';
import '../modules/Auth/resetPassword/views/reset_password_view.dart';
import '../modules/Konselor/edit_jadwal/bindings/edit_jadwal_binding.dart';
import '../modules/Konselor/edit_jadwal/views/edit_jadwal_view.dart';
import '../modules/Konselor/homepageKonselor/bindings/homepage_konselor_binding.dart';
import '../modules/Konselor/homepageKonselor/views/homepage_konselor_view.dart';
import '../modules/Konselor/navigationKonselor/bindings/navigation_konselor_binding.dart';
import '../modules/Konselor/navigationKonselor/views/navigation_konselor_view.dart';
import '../modules/Konselor/profileKonselor/bindings/profile_konselor_binding.dart';
import '../modules/Konselor/profileKonselor/views/profile_konselor_view.dart';
import '../modules/User/addLoan/bindings/add_loan_binding.dart';
import '../modules/User/addLoan/views/add_loan_view.dart';
import '../modules/User/analysis/bindings/analysis_binding.dart';
import '../modules/User/analysis/views/analysis_view.dart';
import '../modules/User/analysis_result/bindings/analysis_result_binding.dart';
import '../modules/User/analysis_result/views/analysis_result_view.dart';
import '../modules/User/calculator/bindings/calculator_binding.dart';
import '../modules/User/calculator/views/calculator_view.dart';
import '../modules/User/challange_page/bindings/challange_page_binding.dart';
import '../modules/User/challange_page/views/challange_page_view.dart';
import '../modules/User/counseling/bindings/counseling_binding.dart';
import '../modules/User/counseling/views/counseling_view.dart';
import '../modules/User/daftar_konseling/bindings/daftar_konseling_binding.dart';
import '../modules/User/daftar_konseling/views/daftar_konseling_view.dart';
import '../modules/User/detailFinance/bindings/detail_finance_binding.dart';
import '../modules/User/detailFinance/views/detail_finance_view.dart';
import '../modules/User/detailLoan/bindings/detail_loan_binding.dart';
import '../modules/User/detailLoan/views/detail_loan_view.dart';
import '../modules/User/editLoan/bindings/edit_loan_binding.dart';
import '../modules/User/editLoan/views/edit_loan_view.dart';
import '../modules/User/editProfile/bindings/edit_profile_binding.dart';
import '../modules/User/editProfile/views/edit_profile_view.dart';
import '../modules/User/education/bindings/education_binding.dart';
import '../modules/User/education/views/education_view.dart';
import '../modules/User/finance/bindings/finance_binding.dart';
import '../modules/User/finance/views/finance_view.dart';
import '../modules/User/homepage/bindings/homepage_binding.dart';
import '../modules/User/homepage/views/homepage_view.dart';
import '../modules/User/loan/bindings/loan_binding.dart';
import '../modules/User/loan/views/loan_view.dart';
import '../modules/User/navigation/bindings/navigation_binding.dart';
import '../modules/User/navigation/views/navigation_view.dart';
import '../modules/User/notification/bindings/notification_binding.dart';
import '../modules/User/notification/views/notification_view.dart';
import '../modules/User/pinjolList/bindings/pinjol_list_binding.dart';
import '../modules/User/pinjolList/views/pinjol_list_view.dart';
import '../modules/User/profile/bindings/profile_binding.dart';
import '../modules/User/profile/views/profile_view.dart';
import '../modules/User/quiz/bindings/quiz_binding.dart';
import '../modules/User/quiz/views/quiz_view.dart';
import '../modules/User/tab_counseling/bindings/tab_counseling_binding.dart';
import '../modules/User/tab_counseling/views/tab_counseling_view.dart';
import '../modules/User/tab_quiz/bindings/tab_quiz_binding.dart';
import '../modules/User/tab_quiz/views/tab_quiz_view.dart';
import '../modules/User/page_toko_koin/bindings/page_toko_koin_binding.dart';
import '../modules/User/page_toko_koin/views/page_toko_koin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION,
      page: () => NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE,
      page: () => HomepageView(),
      binding: HomepageBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.COUNSELING,
      page: () => const CounselingView(),
      binding: CounselingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FINANCE,
      page: () => const FinanceView(),
      binding: FinanceBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ,
      page: () => const QuizView(),
      binding: QuizBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION,
      page: () => const EducationView(),
      binding: EducationBinding(),
    ),
    GetPage(
      name: _Paths.CALCULATOR,
      page: () => CalculatorView(),
      binding: CalculatorBinding(),
    ),
    GetPage(
      name: _Paths.LOAN,
      page: () => const LoanView(),
      binding: LoanBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_LOAN,
      page: () => const EditLoanView(),
      binding: EditLoanBinding(),
    ),
    GetPage(
      name: _Paths.TAB_COUNSELING,
      page: () => const TabCounselingView(),
      binding: TabCounselingBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_KONSELOR,
      page: () => const NavigationKonselorView(),
      binding: NavigationKonselorBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_ADMIN,
      page: () => const NavigationAdminView(),
      binding: NavigationAdminBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_KONSELOR,
      page: () => const ProfileKonselorView(),
      binding: ProfileKonselorBinding(),
    ),
    GetPage(
      name: _Paths.DAFTAR_KONSELING,
      page: () => const DaftarKonselingView(),
      binding: DaftarKonselingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_ADMIN,
      page: () => const ProfileAdminView(),
      binding: ProfileAdminBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE_KONSELOR,
      page: () => const HomepageKonselorView(),
      binding: HomepageKonselorBinding(),
    ),
    GetPage(
      name: _Paths.HOMEPAGE_ADMIN,
      page: () => const HomepageAdminView(),
      binding: HomepageAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDUCATION_ADMIN,
      page: () => const EducationAdminView(),
      binding: EducationAdminBinding(),
    ),
    GetPage(
      name: _Paths.QUIZ_ADMIN,
      page: () => const QuizAdminView(),
      binding: QuizAdminBinding(),
    ),
    GetPage(
      name: _Paths.CHALLANGE_PAGE,
      page: () => ChallangePageView(),
      binding: ChallangePageBinding(),
    ),
    GetPage(
      name: _Paths.TAB_QUIZ,
      page: () => const TabQuizView(),
      binding: TabQuizBinding(),
    ),
    GetPage(
      name: _Paths.ADD_LOAN,
      page: () => const AddLoanView(),
      binding: AddLoanBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_ARTICLE_ADMIN,
      page: () => const EditArticleAdminView(),
      binding: EditArticleAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_VIDEO_ADMIN,
      page: () => const EditVideoAdminView(),
      binding: EditVideoAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_QUIZ_ADMIN,
      page: () => const ListQuizAdminView(),
      binding: EditQuizAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_CHALLENGE_ADMIN,
      page: () => const EditChallengeAdminView(),
      binding: EditChallengeAdminBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_JADWAL,
      page: () => const EditJadwalView(),
      binding: EditJadwalBinding(),
    ),
    GetPage(
      name: _Paths.ANALYSIS,
      page: () => const AnalysisView(),
      binding: AnalysisBinding(),
    ),
    GetPage(
      name: _Paths.ANALYSIS_RESULT,
      page: () => const AnalysisResultView(),
      binding: AnalysisResultBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_LOAN,
      page: () => const DetailLoanView(),
      binding: DetailLoanBinding(),
    ),
    GetPage(
      name: _Paths.CHALLENGE_ADMIN,
      page: () => const ChallengeAdminView(),
      binding: ChallengeAdminBinding(),
    ),
    GetPage(
      name: _Paths.PINJOL_LIST,
      page: () => const PinjolListView(),
      binding: PinjolListBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_FINANCE,
      page: () => const DetailFinanceView(),
      binding: DetailFinanceBinding(),
    ),
    GetPage(
      name: _Paths.PAGE_TOKO_KOIN,
      page: () => const PageTokoKoinView(),
      binding: PageTokoKoinBinding(),
    ),
  ];
}
