import 'dart:convert';

import 'package:shared_preference_module/helper/prerences.dart';

class PreferenceHelper {
  static const userDetails = "user_details";
  static const lessonQuestionDetails = "lesson_question_details";
  static const isFocusMode = "is_focus_mode";

  static const IS_B2B_USER = "isB2BUser";

  static const SIGN_UP_DATE = "sign-up-date";
  static const LAST_APP_OPEN = "last-app-open";
  static const LAST_USED_FEATURE = "last-used-feature";
  static const CHALLENGE_FEATURE_USED_COUNT = "challenge-feature-used-count";
  static const BENCHMARK_FEATURE_USED_COUNT = "challenge-feature-used-count";
  static const LESSON_FEATURE_USED_COUNT = "lesson-feature-used-count";
  static const MOOD_LEARNING_FEATURE_USED_COUNT =
      "mood-learning-feature-used-count";
  static const PAID_USER = "paid-user";

  static const ROLE = "role";
  static const JOB_ROLE = "job-role";
  static const JOB_ROLE_ID = "job-role-id";

  static const SPOTIFY_IS_PAUSED = "isSpotifypaused";
  static const SPOTIFY_PLAY_POSITION = "play_position";

  static Future<String> getSignUpDate() async {
    return await Preferences.getString(SIGN_UP_DATE, "");
  }

  static setSignUpDate(String signUpDate) async {
    await Preferences.setString(SIGN_UP_DATE, signUpDate);
  }

  static Future<String> getLastAppOpenDate() async {
    return await Preferences.getString(LAST_APP_OPEN, "");
  }

  static setLastAppOpenDate(String lastAppOpenDate) async {
    await Preferences.setString(LAST_APP_OPEN, lastAppOpenDate);
  }

  static Future<String> getLastUsedFeature() async {
    return await Preferences.getString(LAST_USED_FEATURE, "");
  }

  static setLastUsedFeature(String lastUsedFeature) async {
    await Preferences.setString(LAST_USED_FEATURE, lastUsedFeature);
  }

  static Future<int> getChallengedFeatureUsedCount() async {
    return await Preferences.getInt(CHALLENGE_FEATURE_USED_COUNT, 0);
  }

  static setChallengedFeatureUsedCount(int challengedFeatureUsedCount) async {
    await Preferences.setInt(
        CHALLENGE_FEATURE_USED_COUNT, challengedFeatureUsedCount);
  }

  static Future<int> getBenchmarkFeatureUsedCount() async {
    return await Preferences.getInt(BENCHMARK_FEATURE_USED_COUNT, 0);
  }

  static setBenchmarkFeatureUsedCount(int benchmarkFeatureUsedCount) async {
    await Preferences.setInt(
        BENCHMARK_FEATURE_USED_COUNT, benchmarkFeatureUsedCount);
  }

  static Future<int> getLessonFeatureUsedCount() async {
    return await Preferences.getInt(LESSON_FEATURE_USED_COUNT, 0);
  }

  static setLessonFeatureUsedCount(int lessonFeatureUsedCount) async {
    await Preferences.setInt(LESSON_FEATURE_USED_COUNT, lessonFeatureUsedCount);
  }

  static Future<int> getMoodLearningFeatureUsedCount() async {
    return await Preferences.getInt(MOOD_LEARNING_FEATURE_USED_COUNT, 0);
  }

  static setMoodLearningFeatureUsedCount(
      int moodLearningFeatureUsedCount) async {
    await Preferences.setInt(
        MOOD_LEARNING_FEATURE_USED_COUNT, moodLearningFeatureUsedCount);
  }

  static Future<bool> getPaidUser() async {
    return await Preferences.getBool(PAID_USER, false);
  }

  static setPaidUser(bool isPaidUser) async {
    await Preferences.setBool(PAID_USER, isPaidUser);
  }

  static Future<bool> getIsB2bUser() async {
    return await Preferences.getBool(IS_B2B_USER, false);
  }

  static Future<String> getRole() async {
    return await Preferences.getString(ROLE, "");
  }

  static setRole(String role) async {
    await Preferences.setString(ROLE, role);
  }

  static Future<String> getJobRole() async {
    return await Preferences.getString(JOB_ROLE, "");
  }

  static setJobRole(String role, String jobRoleId) async {
    await Preferences.setString(JOB_ROLE, role);
    await Preferences.setString(JOB_ROLE_ID, jobRoleId);
  }

  static Future<String> getJobRoleId() async {
    return await Preferences.getString(JOB_ROLE_ID, "");
  }

  // static setUserDetails(UserDetails userDetail) async {
  //   await Preferences.setString(userDetails, json.encode(userDetail));
  // }

  // static Future<UserDetails?> getUserDetails() async {
  //   UserDetails? response;
  //   String data = await Preferences.getString(userDetails, null);
  //   if (data != null && data.isNotEmpty) {
  //     response = UserDetails.fromJson(json.decode(data));
  //   }
  //   return response;
  // }

  // static setLessonQuestionDetails(
  //     LessonQuestionsResultModel? lessonQuestionsResultModel) async {
  //   await Preferences.setString(
  //       lessonQuestionDetails, json.encode(lessonQuestionsResultModel));
  // }

  // static Future<LessonQuestionsResultModel?> getLessonQuestionDetails() async {
  //   LessonQuestionsResultModel? response;
  //   String data = await Preferences.getString(lessonQuestionDetails, null);
  //   if (data != null && data.isNotEmpty && data != 'null') {
  //     //print('Data: $data');
  //     response = LessonQuestionsResultModel.fromJson(json.decode(data));
  //   }
  //   return response;
  // }

  static setFocusMode(bool isFocusModeEnable) async {
    await Preferences.setBool(isFocusMode, isFocusModeEnable);
  }

  static Future<bool> isFocusModeEnable() async {
    return await Preferences.getBool(isFocusMode, false);
  }

  static setSpotifyPlayPosition(int position) async {
    await Preferences.setInt(SPOTIFY_PLAY_POSITION, position);
  }

  static Future<int> getIsPlayPosition() async {
    return await Preferences.getInt(SPOTIFY_PLAY_POSITION, -1);
  }

//   static Future<bool> getPlayerState() async {
//     try {
//       SpotifySdk.getPlayerState().then((value) async => {
//             if (value!.isPaused == false)
//               {
//                 SpotifySdk.pause(),
//                 locator<MoodLearnerViewModel>().isSpotifyPlaying = false,
//               },
//           });
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }

//   static Future<void> clearPreference() async {
//     // Please check if signin with Facbook
//     signOutFacebook();
//     await Preferences.remove(IS_LOGIN);
//     await Preferences.remove(ACCESSTOKEN);
//     await Preferences.remove(REFRESHTOKEN);
//     await Preferences.remove(USERID);
//     await Preferences.remove(Mood);
//     await Preferences.remove(MoodCaptureDate);
//     await Preferences.remove(userDetails);
//     await Preferences.remove(isFocusMode);
//   }

//   static Future<void> signOutFacebook() async {
//     final facebookLogin = FacebookLogin();
//     await facebookLogin.logOut();
//   }
// }

}
