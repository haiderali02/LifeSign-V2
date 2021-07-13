//
//  AppStrings.swift
//  LifeSign
//
//  Created by Haider Ali on 26/03/2021.
//  Copyright © 2021 softwarealliance. All rights reserved.
//

import Foundation

class AppStrings: NSObject {
    
    ///
    // MARK:- GENERAL STRINGS -
    ///
    
    static func getBackButtonString() -> String {
        return StringsManager.shared.back ?? "Back"
    }
    
    static func getSearchString() -> String {
        return StringsManager.shared.search ?? "Search"
    }
    
    static func getYouString () -> String {
        return StringsManager.shared.you ?? "YOU"
    }
    
    static func getFriendPendigString () -> String {
        return  StringsManager.shared.request_pending ?? "Request Pending"
    }
    
    static func getWaitingString () -> String {
        return StringsManager.shared.request_sent ?? "Request Sent"
    }
    
    static func getAcceptString () -> String {
        return StringsManager.shared.accept ?? "Accept"
    }
    
    static func getRejectString () -> String {
        return StringsManager.shared.reject ?? "Reject"
    }
    
    static func getNoDatFoundString () -> String {
        return StringsManager.shared.no_record_found ?? "No record found"
    }
    
    static func getDoneString () -> String {
        return StringsManager.shared.done ?? "Done"
    }
    
    static func getErrorTitleString () -> String {
        return StringsManager.shared.error ?? "Error"
    }
    static func getFacebookFailError () -> String {
        return StringsManager.shared.unable_to_login_with_facebook_this_time ?? "Unable to Login with facebook this time"
    }
    static func getFBLoginCancelString () -> String {
        return StringsManager.shared.you_have_declined_login_permission ?? "You have declined login permission"
    }
    static func getAlertString () -> String {
        return StringsManager.shared.alert ?? "Alert"
    }
    
    static func messageLimitExceed() -> String {
        return StringsManager.shared.you_are_not_subscribed_to_send_message_over_140_characters_please_buy_message_package ?? "You are not subscribed to send message over 140 characters. Please buy package."
    }
    
    static func restorePurchases() -> String {
        return StringsManager.shared.restore_purchase ?? "Restore Purchase"
    }
    
    static func dsContactsAvailable() -> String {
        return StringsManager.shared.you_have_no_more_free_dailysign_contacts_available ?? "You have no more free DailySign contacts available"
    }
    
    static func getNoFriendInSOS () -> String {
        return StringsManager.shared.you_dont_have_any_sos_friend_would_you_like_to_add_new_sos_friend ?? "You don't have any sos friend. Would you like to add new sos friend?"
    }
    
    static func getNotifiedString () -> String {
        return StringsManager.shared.has_been_notified_successfully ?? "has been notified successfully."
    }
    
    static func getAllFieldsRequired () -> String {
        return StringsManager.shared.all_fields_are_required ?? "All fields are required!"
    }
    
    static func getPasswordMismatch () -> String {
        return StringsManager.shared.password_and_confirm_password_should_be_same ?? "Password and confirm password should be same."
    }
    
    static func getNewPasswordMismatch () -> String {
        return StringsManager.shared.new_password_and_confirm_password_should_be_same ?? "New password and confirm password should be same."
    }
    
    static func getOKButtonString () -> String {
        return StringsManager.shared.ok ?? "OK"
    }
    
    static func getAppWillNotWork() -> String {
        return StringsManager.shared.app_will_not_work ?? "If you don't accept LifeSign terms of use, app won’t work"
    }
    
    static func getEmailString() -> String {
        return StringsManager.shared.email_address ?? "Email Address"
    }
    static func getPasswordString() -> String {
        return StringsManager.shared.password ?? "Password"
    }
    static func getOldPasswordString() -> String {
        return StringsManager.shared.old_password ?? "Old Password"
    }
    static func getConfirmPasswordString() -> String {
        return StringsManager.shared.confirm_password ?? "Confirm Password"
    }
    static func getNetworkNotAvailableString() -> String {
        return StringsManager.shared.network_not_available ?? "Network Not Available"
    }
    static func getSomwthingWentWrong() -> String {
        return StringsManager.shared.something_went_wrong ?? "Something went wrong"
    }
    static func getNewPasswordPasswordString() -> String {
        return StringsManager.shared.new_password ?? "New Password"
    }
    static func getSendString() -> String {
        return StringsManager.shared.send ?? "Send"
    }
    static func getCancelString() -> String {
        return StringsManager.shared.cancel ?? "Cancel"
    }
    
    static func getOpenSetting() -> String {
        return StringsManager.shared.open_settings ?? "Open Settings"
    }
    
    static func appNeedsContactString() -> String{
        return StringsManager.shared.lifesign_app_requires_access_to_contacts_to_proceed_go_to_settings_to_grant_access ?? "LifeSign app requires access to Contacts to proceed. Go to Settings to grant access."
    }
    
    static func getDeleteConversation() -> String {
        return StringsManager.shared.delete_conversation ?? "Delete Conversation"
    }
    
    static func getInvalidEmailAddressString () -> String {
        return StringsManager.shared.invalid_email ?? "Invalid Email"
    }
    static func getInvalidEmailMessageString () -> String {
        return StringsManager.shared.your_email_address_is_not_valid ?? "Your email address is not valid"
    }
    static func getPasswordLengthString () -> String {
        return StringsManager.shared.password_length_must_be_minimum_of_6_characters ?? "Password length must be minimum of 6 characters"
    }
    static func getNextButtonString () -> String {
        return StringsManager.shared.next ?? "Next"
    }
    static func getSignUpString () -> String {
        return StringsManager.shared.sign_up ?? "Sign up"
    }
    static func getSuccessString () -> String {
        return StringsManager.shared.success ?? "Success"
    }
    
    static func getRestoreSuccessString () -> String {
        return StringsManager.shared.all_purchases_restored ?? "Success"
    }
    
    static func getCodeResentString () -> String {
        return StringsManager.shared.code_resent_successfully ?? "Code resent successfully!"
    }
    
    static func getPurchaseSuccessString() -> String {
        return StringsManager.shared.your_transaction_have_been_stored_successfully ?? "All of your purchases have been restored"
    }
    
    ///
    // MARK:- OKSIGN -
    ///
    
    static func getOkSignRemind () -> String {
        return StringsManager.shared.remind ?? "Remind"
    }
    
    static func getOkSignFriendsStrig () -> String {
        return StringsManager.shared.oksign_friends ?? "OkSign Friends"
    }
    
    static func getIamOkString () -> String {
        return StringsManager.shared.im_ok ?? "I'm OK"
    }
    static func getOkSignTitle () -> String {
        return StringsManager.shared.oksign ?? "OkSign"
    }
    
    static func getCheckFriendString () -> String {
        return StringsManager.shared.check_friends ?? "Check Friends"
    }
    static func getLSFriends () -> String {
        return StringsManager.shared.lifesign_friends ?? "LifeSign Friends"
    }
    static func getFriendRequestString () -> String {
        return StringsManager.shared.friend_request ?? "Friend Request"
    }
    
    static func getTellFriendsString () -> String {
        return StringsManager.shared.tell_friends ?? "Tell Friends"
    }
    
    static func getOkSignSubTitle () -> String {
        return StringsManager.shared.an_easy_way_to_let_your_loved_ones_know_you_are_ok ?? "An easy way to let your loved ones know you are OK"
    }
    static func getOkSignDescriptionOne () -> String {
        return StringsManager.shared.add_and_find_your_friends_via_oksign ?? "Add and find your friends Via OkSign"
    }
    static func getOkSignDescriptionTwo () -> String {
        return StringsManager.shared.check_your_friends_medical_condition_that_they_are_ok_or_not ?? "Check that your friends are ok"
    }
    static func getOkSignDescriptionThree () -> String {
        return StringsManager.shared.tell_your_friends_about_your_medical_condition_that_is_ok_or_not ?? "Tell your friends that you are ok"
    }
    static func getOkSignDescriptionFour () -> String {
        return StringsManager.shared.use_this_functionality_every_1_hour ?? "Use this functionality every 1 hour"
    }
    
    ///
    // MARK:- SOS -
    ///
    
    static func getSOSPageTitle() -> String {
        return StringsManager.shared.emergency_help_needed ?? "Emergency help needed?"
    }
    
    static func getResetString() -> String {
        return StringsManager.shared.reset ?? "Reset"
    }
    
    static func getSOSPageSubTitle() -> String {
        return StringsManager.shared.just_hold_the_button_for_3_sec ?? "Just hold the button for 3 sec"
    }
    
    static func getPushForThreeSecString() -> String {
        return StringsManager.shared.push_this_for_3_sec ?? "PUSH THIS FOR 3 SEC"
    }
    static func sosSents() -> String {
        return StringsManager.shared.sos_sent ?? "SOS Sent"
    }
    static func sosReceived() -> String {
        return StringsManager.shared.sos_received ?? "SOS Received"
    }
    static func getSeeAllString () -> String {
        return StringsManager.shared.see_all ?? "See All"
    }
    static func getSOSTitle () -> String {
        return StringsManager.shared.sos ?? "SOS"
    }
    
    static func getONString () -> String {
        return StringsManager.shared.switch_on ?? "ON"
    }
    
    static func getOffString () -> String {
        return StringsManager.shared.switch_off ?? "OFF"
    }
    
    static func getShopTabSting () -> String {
        return StringsManager.shared.tabb_shop ?? "Shop"
    }
    static func getSOSListingTitle () -> String {
        return StringsManager.shared.sos_listing ?? "SOS Listing"
    }
    static func getAddNewString () -> String {
        return StringsManager.shared.add_new ?? "Add New"
    }
    
    static func getAddNowString () -> String {
        return StringsManager.shared.add_now ?? "Add Now"
    }
    
    static func getSOSSubTitle () -> String {
        return StringsManager.shared.if_you_are_in_emergency_conditionsend_request ?? "if you are in emergency condition,send request"
    }
    static func getSOSDescriptionOne () -> String {
        return StringsManager.shared.add_and_find_your_friends_via_sos ?? "Add and find your friends Via SOS"
    }
    static func getSOSDescriptionTwo () -> String {
        return StringsManager.shared.send_and_received_sos_in_an_emergency_condition ?? "Send and received SOS in an emergency condition"
    }
    static func getSOSDescriptionThree () -> String {
        return StringsManager.shared.you_can_add_more_friends_just_in_case ?? "You can add more friends-just in case"
    }
    static func getSOSDescriptionFour () -> String {
        return StringsManager.shared.wait_for_your_friends_to_come_and_help_you_or_your_friends_are_waiting_for_you_to_come_and_help ?? "Wait for your friends to come and help you, or your friends are waiting for you to come and help"
    }
    static func getSOSDescriptionFive () -> String {
        return StringsManager.shared.use_this_functionality_anytime_when_you_want ?? "Use this functionality anytime when you want"
    }
    
    ///
    // MARK:- DAILY SIGN -
    ///
    
    static func getDailySignTitle () -> String {
        return StringsManager.shared.dailysign ?? "DailySign"
    }
    
    static func getWhoWillSendString () -> String {
        return StringsManager.shared.who_is_going_to_send_dailysign ?? "Who is going to send DailySign?"
    }
    
    static func getDailySignSubTitle () -> String {
        return StringsManager.shared.keep_connecting_with_your_friends_and_live_every_day ?? "Keep connecting with your friends and live every day"
    }
    static func getDailySignDescriptionOne () -> String {
        return StringsManager.shared.add_and_find_your_new_friends_via_dailysign ?? "Add and find your new friends via DailySign"
    }
    static func getDailySignDescriptionTwo () -> String {
        return StringsManager.shared.set_the_timewhen_you_want_to_receive_dailysign_to_your_friends ?? "Set the time,when you want to receive DailySign to your friends"
    }
    static func getDailySignDescriptionThree () -> String {
        return StringsManager.shared.every_day_you_will_receive_a_dailysign_alert_from_your_friends ?? "Every day you will receive a DailySign alert from your friends"
    }
    static func getDailySignDescriptionFour () -> String {
        return StringsManager.shared.every_day_you_can_send_dailysign_alert_to_your_friends ?? "Every day you can send DailySign alert to your friends"
    }
    
    static func sosSeen() -> String {
        return StringsManager.shared.seen ?? "Seen"
    }
    static func sosUnSeen() -> String {
        return StringsManager.shared.not_seen ?? "Not seen"
    }
    static func sosMarkedSeen() -> String {
        return StringsManager.shared.marked_seen ?? "Marked Seen"
    }
    static func sosGotIT() -> String {
        return StringsManager.shared.got_it ?? "GOT IT"
    }
    
    
    ///
    // MARK:- FRIENDS SCREEN -
    ///
    
    static func getFriendsString () -> String {
        return StringsManager.shared.friends ?? "Friends"
    }
    static func getNewChatString () -> String {
        return StringsManager.shared.new_chat ?? "New Chat"
    }
    
    static func getFriendsTitle () -> String {
        return StringsManager.shared.friends_you_dont_know ?? "Friends you don't know"
    }
    static func getFriendsSubTitle () -> String {
        return StringsManager.shared.are_you_lonely_or_do_you_just_want_new_friends_arounds_the_world ?? "Are you lonely or do you just want new friends arounds the world?"
    }
    static func getFriendsDescriptionOne () -> String {
        return StringsManager.shared.go_to_friends_page_and_tap_on_add_icon ?? "Go to friends page and tap on add icon"
    }
    static func getFriendsDescriptionTwo () -> String {
        return StringsManager.shared.choose_between_locally_nationally_and_the_internationally_for_new_friendsyou_want_to_find ?? "Choose between locally ,nationally and the internationally for new friends,you want to find"
    }
    static func getFriendsDescriptionThree () -> String {
        return StringsManager.shared.send_friend_request_by_click_on_the_add_button ?? "Send friend request by click on the add button"
    }
    static func getFriendsDescriptionFour () -> String {
        return StringsManager.shared.when_you_are_friends_you_can_add_them_to_poke_game_or_chat_and_get_to_know_each_other ?? "When you are friends you can add them to Poke Game or chat and get to know each other"
    }
    
    ///
    // MARK:- GAME SCREEN -
    ///
    
    static func getServicesTitle () -> String {
        return StringsManager.shared.services ?? "Services"
    }
    
    static func getGameTitle () -> String {
        return StringsManager.shared.poke_games ?? "Poke Games"
    }
    static func getGameSubTitle () -> String {
        return StringsManager.shared.easy_way_to_be_top_of_mind_with_your_family_or_loved_one ?? "Easy way to be Top of mind with your family or loved one"
    }
    static func getGameDescriptionOne () -> String {
        return StringsManager.shared.tap_on_the_poke_game_icon ?? "Tap on the Poke Game icon"
    }
    static func getGameDescriptionTwo () -> String {
        return StringsManager.shared.then_tap_on_the_yellow_button_to_add_friends ?? "Then tap on the yellow button to add friends"
    }
    static func getGameDescriptionThree () -> String {
        return StringsManager.shared.tap_on_the_name_to_send_a_game_request ?? "Tap on the name to send a game request"
    }
    static func getGameDescriptionFour () -> String {
        return StringsManager.shared.play_with_your_friends_until_one_of_you_does_not_have_tie_to_poke_and_get_on_there_hits_list ?? "Play with your friends untill one of you does not have tie to poke and get on ther hits list"
    }
    
    ///
    // MARK:- LANGUAGE SCREEN -
    ///
    static func getLanguageTitle () -> String {
        return StringsManager.shared.please_select_your_language ?? "Please select your language"
    }
    
    //
    // MARK:- WELCOME SCREEN -
    //
    static func getWelcomeScreenTitle () -> String {
        return StringsManager.shared.welcome_to_lifesign ?? "Welcome to LifeSign"
    }
    static func getWelcomeLoginWitApple () -> String {
        return StringsManager.shared.sign_in_with_apple ?? "Sign in with Apple"
    }
    static func getWelcomeLoginWitFacebook () -> String {
        return StringsManager.shared.login_with_facebook ?? "Login with Facebook"
    }
    static func getWelcomeLoginWitEmail () -> String {
        return StringsManager.shared.login ?? "Login"
    }
    static func getWelcomeAreYouNewUser () -> String {
        return StringsManager.shared.are_you_a_new_user ?? "Are you a new user?"
    }
    static func getWelcomeRegisterAccount () -> String {
        return StringsManager.shared.register_new_account ?? "Register new account"
    }
    
    ///
    // MARK:- LOGIN SCREEN -
    ///
    
    static func getLoginScreenTitle () -> String {
        return StringsManager.shared.login_to_your_account ?? "Login to your account"
    }
    static func getLoginRememverMe () -> String {
        return StringsManager.shared.remember_me ?? "Remember me"
    }
    static func getLoginButtonString () -> String {
        return StringsManager.shared.login ?? "Login"
    }
    static func getLoginForgotPasswordString () -> String {
        return StringsManager.shared.forgot_password ?? "Forgot Password?"
    }
    static func getLoginEmailPlaceHolder () -> String {
        return StringsManager.shared.eg_johndoecom ?? "eg. john@doe.com"
    }
    static func getLoginRegisterString () -> String {
        return StringsManager.shared.register ?? "Register"
    }
    
    ///
    // MARK:- RESET SCREEN -
    ///
    
    static func getResetPasswordTitle () -> String {
        return StringsManager.shared.reset_password ?? "Reset Password"
    }
    static func getUpdatePasswordString () -> String {
        return StringsManager.shared.change_password ?? "Change Password"
    }
    static func getResetEmailPlaceHolder () -> String {
        return StringsManager.shared.enter_your_email_address ?? "Enter your email address"
    }
    
    ///
    // MARK:- SIGNUP SCREEN -
    ///
    
    static func getSignupScreenTitle () -> String {
        return StringsManager.shared.register_your_account_now ?? "Register your account now"
    }
    static func getSignupFullNameTitle () -> String {
        return StringsManager.shared.full_name ?? "Full Name"
    }
    static func getSignupTermsAndCondition() -> String {
        return StringsManager.shared.i_accept_the_terms_and_conditions ?? "I accept the terms and conditions"
    }
    static func getSignupUserConsent() -> String {
        return StringsManager.shared.i_give_my_consent_to_lifesign ?? "I give my consent to LifeSign"
    }
    static func getSignupAlreadyaveAccountString () -> String {
        return StringsManager.shared.already_have_an_account ?? "Already have an account?"
    }
    
    ///
    // MARK:- SIGNUP SCREEN MORE DETAILS -
    ///
    
    static func getSignupMoreDetailScreenTitle () -> String {
        return StringsManager.shared.we_need_few_more_details ?? "We need few more details"
    }
    static func getSignupMoreDetailContacNumber () -> String {
        return StringsManager.shared.contact_number ?? "Contact Number"
    }
    static func getSignupDetailTimeZone() -> String {
        return StringsManager.shared.select_time_zone ?? "Select Time Zone"
    }
    static func getSignupDetailScreenZipCode() -> String {
        return StringsManager.shared.zip_code ?? "Zip code"
    }
    
    ///
    // MARK:- VERIFICATION SCREEN -
    ///
    
    static func getOTPBackButtonString () -> String {
        return StringsManager.shared.otp_verification ?? "OTP Verification"
    }
    static func getOTPCodeScreenTitle () -> String {
        return StringsManager.shared.verification_code ?? "Verification Code"
    }
    static func getOTPCodeSubTitle() -> String {
        return StringsManager.shared.a_verification_code_has_been_sent_to_your_email ?? "A verification code has been sent to your email: "
    }
    static func getOTPNotReceivedCode() -> String {
        return StringsManager.shared.did_not_received_the_code ?? "Did not received the code?"
    }
    static func getOTPResend() -> String {
        return StringsManager.shared.resend ?? "Resend"
    }
    
    ///
    // MARK:- SUCCESS UPDATE SCREEN -
    ///
    static func getSuccessUpdateTitle() -> String {
        return StringsManager.shared.password_updated_successfully_please_login_to_your_account ?? "Password updated successfully. Please login to your account"
    }
    
    static func getPasswordUpdateSuccessMessage() -> String {
        return StringsManager.shared.password_updated_successfully ?? "Password updated successfully."
    }
    static func getSOSNumberSuccessMessage() -> String {
        return StringsManager.shared.sos_number_added_successfully ?? "SOS number added successfully."
    }
    
    ///
    // MARK:- FRIENDS -
    ///
    
    static func getAddFriendString() -> String {
        return StringsManager.shared.add ?? "Add"
    }
    static func getViewMoreString() -> String {
        return StringsManager.shared.view_more ?? "View More"
    }
    static func getRequestSentString() -> String {
        return StringsManager.shared.request_sent ?? "Request Sent"
    }
    
    static func getViewRequestString() -> String {
        return StringsManager.shared.view_request ?? "View Request"
    }
    
    static func getSendInviteForLifeSign() -> String {
        return StringsManager.shared.invite ?? "Invite"
    }
    
    static func gameInvitationReceived() -> String {
        return StringsManager.shared.invitation_received ?? "Invitation Received"
    }
    static func gameInvitationSent() -> String {
        return StringsManager.shared.invitation_sent ?? "Invitation Sent"
    }
    
    static func getInvitationSentString() -> String {
        return StringsManager.shared.invitation_sent ?? "Invitation Sent"
    }
    
    static func getCancelRequestString() -> String {
        return StringsManager.shared.cancel_request ?? "Cancel Request"
    }
    
    static func getTabFriendsTitle() -> String {
        return StringsManager.shared.my_friends ?? "My Friends"
    }
    
    static func requestSentSuccess() -> String {
        return StringsManager.shared.request_sent_successfully ?? "Request sent successfully!"
    }
    
    static func requestSentFail() -> String {
        return StringsManager.shared.unable_to_send_request_this_time ?? "Unable to send request this time!"
    }
    static func requestAcceptFail() -> String {
        return StringsManager.shared.unable_to_accept_request_this_time ?? "Unable to accept request this time!"
    }
    
    static func requestRejectFail() -> String {
        return StringsManager.shared.unable_to_reject_request_this_time ?? "Unable to reject request this time!"
    }
    
    static func getPeopleTitle() -> String {
        return StringsManager.shared.people ?? "People"
    }
    static func getInviteFriendsTitle() -> String {
        return StringsManager.shared.invite_friends ?? "Invite Friends"
    }
    
    static func getTabLocalFriendsTitle() -> String {
        return StringsManager.shared.local ?? "Local"
    }
    
    static func getInternationalFriendTitle() -> String {
        return StringsManager.shared.international ?? "International"
    }
    static func getNationalFriendTitle() -> String {
        return StringsManager.shared.national ?? "National"
    }
    
    static func getAddinSOSString() -> String {
        return StringsManager.shared.add_in_sos_friends_list ?? "Add in SOS Friends List"
    }
    
    static func getAddedString() -> String {
        return StringsManager.shared.added ?? "Added"
    }
    static func getNOTAddedString() -> String {
        return StringsManager.shared.not_added ?? "Not Added"
    }
    static func getSendMessageString() -> String {
        return StringsManager.shared.send_message ?? "Send Message"
    }
    
    static func getAddinLifeSignString() -> String {
        return StringsManager.shared.add_in_lifesign_friends_list ?? "Add in DailySign Friends List"
    }
    
    static func getAddinOKSignString() -> String {
        return  StringsManager.shared.add_in_ok_friends_list ?? "Add in OK Friends List"
    }
    
    static func getAddinHealthSignString() -> String {
        return StringsManager.shared.add_in_health_friends_list ?? "Add in Health Friends List"
    }
    
    static func getAddinBlockString() -> String {
        return StringsManager.shared.block ?? "Block"
    }
    
    static func getDeleteString() -> String {
        return StringsManager.shared.delete ?? "Delete"
    }
    static func getReadString() -> String {
        return StringsManager.shared.read ?? "Read"
    }
    static func getRemoveString() -> String {
        return StringsManager.shared.remove ?? "Remove"
    }
    ///
    // MARK:- NOTIFICATIONS -
    ///
    static func getNotificationString() -> String {
        return StringsManager.shared.notifications ?? "Notifications"
    }
    
    ///
    // MARK:- USER PROFILE -
    ///
    
    static func getUserProfileBackButtonString() -> String {
        return StringsManager.shared.profile ?? "Profile"
    }
    static func getConnectWatcString() -> String {
        return StringsManager.shared.connect_watch ?? "Connect Watch"
    }
    static func getRequestOnStrangerString() -> String {
        return StringsManager.shared.stranger_request ?? "Stranger Request"
    }
    static func userFriendsBlockStreing() -> String {
        return StringsManager.shared.blocked_users ?? "Blocked Users"
    }
    
    static func getBlockString() -> String {
        return StringsManager.shared.block ?? "Block"
    }
    
    static func getLogoutString() -> String {
        return StringsManager.shared.logout ?? "Logout"
    }
    
    static func getUserEditProfile() -> String {
        return StringsManager.shared.edit_profile ?? "Edit Profile"
    }
    static func getChangeProfileText() -> String {
        return StringsManager.shared.change_profile_image ?? "Change Profile Image"
    }
    static func getFirstNameText() -> String {
        return StringsManager.shared.first_name ?? "First Name"
    }
    static func getLasttNameText() -> String {
        return StringsManager.shared.last_name ?? "Last Name"
    }
    static func getSaveButton() -> String {
        return StringsManager.shared.save ?? "Save"
    }
    static func getBuySMSString() -> String {
        return StringsManager.shared.buy_sms ?? "Buy SMS"
    }
    
    static func getBuyString() -> String {
        return StringsManager.shared.buy ?? "Buy"
    }
    
    static func getAcceptTerms() -> String {
        return StringsManager.shared.you_must_accept_our_terms_and_conditions ?? "You must accept our terms and conditions"
    }
    
    static func getBuyMessageString() -> String {
        return StringsManager.shared.buy_messages_package ?? "Buy Messages Package"
    }
    
    static func getMoreDSContacs() -> String {
        return StringsManager.shared.buy_more_contacts ?? "Buy More Contacts"
    }
    
    
    static func getGotoFriends() -> String {
        return StringsManager.shared.go_to_friends ?? "Go to friends"
    }
    
    static func getChangeString() -> String {
        return StringsManager.shared.change ?? "Change"
    }
    static func getMessaesString() -> String {
        return StringsManager.shared.messages ?? "Messages"
    }
    
    ///
    // MARK:- SETTINGS -
    ///
    
    static func getSettingsTitle() -> String {
        return StringsManager.shared.settings ?? "Settings"
    }
    
    static func getLeaderBoardString() -> String {
        return StringsManager.shared.leaderboard ?? "Leaderboard"
    }
    
    static func getBlockedFriends() -> String {
        return StringsManager.shared.blocked_users ?? "Blocked Users"
    }
    static func getUnblockedString() -> String {
        return StringsManager.shared.unblock ?? "Unblock"
    }
    static func getFAQString() -> String {
        return StringsManager.shared.faqs ?? "FAQ's"
    }
    static func getOnlyInEngAndDanish() -> String {
        return StringsManager.shared.only_in_english_and_danish ?? "Only in English and Danish"
    }
    static func getDontWantRqStrngr() -> String {
        return StringsManager.shared.dont_want_friend_requests_from_strangers ?? "Don't want friend requests from strangers"
    }
    static func getSoundOnOfString() -> String {
        return StringsManager.shared.sound_onoff ?? "Sound ON/OFF"
    }
    static func linksForTermCondition() -> String {
        return StringsManager.shared.link_for_terms_and_conditions ?? "Link for Terms and Conditions"
    }
    static func getDownloadGDPR() -> String {
        return StringsManager.shared.download_gdpr_info ?? "Download GDPR info"
    }
    static func getDeleteProfileString() -> String {
        return StringsManager.shared.delete_profile ?? "Delete Profile"
    }
    static func getAddSOSNumString() -> String {
        return StringsManager.shared.mobile_number_to_receive_sos_sms_and_lifesign_sms_warning ?? "Mobile Number to receive SOS SMS and LifeSign SMS warning"
    }
    static func getAreYouSureString () -> String {
        return StringsManager.shared.are_you_sure ?? "Are you sure?"
    }
    static func getDeleteAccountString () -> String {
        return StringsManager.shared.do_you_want_to_delete_your_account ?? "Do you want to delete your account?"
    }
    
    ///
    // MARK:- Daily SIGN EDIT USER -
    ///
    
    static func getEditNickName () -> String {
        return StringsManager.shared.edit_nick_name ?? "Edit nick name"
    }
    static func getEditLSTime () -> String {
        return StringsManager.shared.edit_lifesign_time ?? "Edit LifeSign time"
    }
    static func getSwapeString () -> String {
        return StringsManager.shared.swap_lifesign ?? "Swap LifeSign"
    }
    static func getRemoveFromLifeSign () -> String {
        return StringsManager.shared.remove_from_lifesign ?? "Remove from LifeSign"
    }
    
    static func getShareLifeSign () -> String {
        return StringsManager.shared.hi_lets_signup_for_the_lifesign_app_https ?? "Hi, Lets signup for the LifeSign App https://apps.apple.com/us/app/lifesign/id1499793115"
    }
    
    ///
    // MARK:- SHOP -
    ///
    
    static func getWatchVidTwoClicks () -> String {
        return StringsManager.shared.watch_video__earn_2_free_autoclicks ?? "Watch Video & earn 2 free autoclicks."
    }
    static func getWatchVidTwoSMS () -> String {
        return StringsManager.shared.watch_video__earn_1_free_sms ?? "Watch Video & earn 1 free SMS."
    }
    
    static func getPurchasesDSContactString() -> String {
        return StringsManager.shared.extra_dailysign_contacts_available ?? "Extra DailySign contacts available"
    }
    static func getPurchasesClicksString() -> String {
        return StringsManager.shared.extra_clicks_available ?? "Extra clicks available"
    }
    static func getPurchasesGamesString() -> String {
        return StringsManager.shared.extra_poke_games_available ?? "Extra Poke Games available"
    }
    
    static func getPurchasesRemovedAdsString() -> String {
        return StringsManager.shared.remove_ads_in_bottom ?? "Remove ads in bottom"
    }
    
    static func getMessageContactPurchased() -> String {
        return StringsManager.shared.available_contacts_to_send_140_plus_characters_message ?? "Available contacts to send 140 plus characters message"
    }
    
    static func getPurchasesSMSString() -> String {
        return StringsManager.shared.available_sms ?? "Available SMS"
    }
    
    
    
    ///
    // MARK:- DAILYSIGN -
    ///
    
    static func getAwaitingDS() -> String {
        return StringsManager.shared.awaiting_dailysign ?? "Awaiting DailySign"
    }
    
    static func getSendDS() -> String {
        return StringsManager.shared.send_dailysign ?? "Send DS"
    }
    
    
    ///
    // MARK:- GAME -
    ///
    
    static func getBuyAutoClicks() -> String {
        return StringsManager.shared.buy_more ?? "Buy more"
    }
    
    static func getOpponentTurn() -> String {
        return StringsManager.shared.opponent_turn ?? "Opponent Turn"
    }
    static func getYourTurn() -> String {
        return StringsManager.shared.your_turn ?? "Your Turn"
    }
    
    static func getAutoClicks() -> String {
        return StringsManager.shared.auto_clicks ?? "Auto clicks"
    }
    
    static func getBuyMoreGames() -> String {
        return StringsManager.shared.buy_more_games ?? "Buy more games"
    }
    
    static func getCurrentStatus() -> String {
        return StringsManager.shared.current_status ?? "Current Status"
    }
    
    static func getEarnedBadge() -> String {
        return StringsManager.shared.game_points ?? "Game Points"
    }
    static func youHaveString() -> String {
        return StringsManager.shared.you_have ?? "You have"
    }
    static func freeGamesString() -> String {
        return StringsManager.shared.free_games ?? "free games"
    }
    
    static func playAgainString() -> String {
        return StringsManager.shared.play_game ?? "Play Again"
    }
    
    static func areYouSureString() -> String {
        return StringsManager.shared.are_you_sure ?? "Are you sure?"
    }
    
    static func willTakeExtraPokeGame() -> String {
        return StringsManager.shared.do_you_want_to_remove_your_poke_game_friend_re_add_will_take_1_extra_game ?? "Do you want to remove your Poke Game friend? Re add will take 1 extra game."
    }
    
    static func YESString() -> String {
        return StringsManager.shared.yes ?? "YES"
    }
    static func NOString() -> String {
        return StringsManager.shared.no ?? "NO"
    }
    static func sendInvitation() -> String {
        return StringsManager.shared.send_invitation ?? "Send Invitation"
    }
    
    static func youWonString() -> String {
        return StringsManager.shared.you_won ?? ("You Won")
    }
    
    static func youLossString() -> String {
        return StringsManager.shared.you_loss ?? "You Loss"
    }
    
    static func wantsToAddYouGameFriend() -> String {
        return StringsManager.shared.game_friend_invited ?? "Game Friend Invited"
    }
    
    static func invitationSent() -> String {
        return StringsManager.shared.invitation_sent ?? "Invitation Sent"
    }
    
    static func wantsToPlayGame() -> String {
        return StringsManager.shared.wants_to_play_game ?? "Wants to play Game"
    }
    
    static func gameFriendInviation() -> String {
        return StringsManager.shared.game_friend_invitation ?? "Game Friend Invitation"
    }
    
    static func playGameString() -> String {
        return StringsManager.shared.play_game ?? "Play Game"
    }
    
    static func howToUserFunctions() -> String {
        return StringsManager.shared.how_to_use_function ?? "How to use function"
    }
    
    static func pokeGameInfo() -> String {
        return StringsManager.shared.poke_game_info ?? "Poke Game Info"
    }
    
    static func pokeGamePoints() -> String {
        return StringsManager.shared.poke_game_info ?? "Poke Game Points"
    }
    
    static func sosInfo() -> String {
        return StringsManager.shared.sos_info ?? "SOS Info"
    }
    static func friendsInfo() -> String {
        return StringsManager.shared.friends_info ?? "Friends Info"
    }
    
    // MARK:- GAME INFO -
    
    static func one_point_to_start_game() -> String {
        return  StringsManager.shared.one_point_to_start_game ?? "1 point to start Poke Game"
    }
    
    static func three_point_to_start_game() -> String {
        return  StringsManager.shared.three_point_to_start_game ?? "3 point to loss Poke Game"
    }
    
    static func ten_point_to_start_game() -> String {
        return  StringsManager.shared.ten_point_to_start_game ?? "10 point to win Poke Game"
    }
    
    static func gameRedColor() -> String {
        return StringsManager.shared.red_color_indicates_to_invite_a_friend_to_play_poke_game ?? "Red color indicates to invite a friend to play Poke Game"
    }
    
    static func gameGreenColor() -> String {
        return StringsManager.shared.green_color_indicates_that_your_poke_game_is_in_progress ?? "Green color indicates that your Poke Game is in progress"
    }
    
    static func gameYellowColor() -> String {
        return StringsManager.shared.yellow_color_indicates_to_acceptreject_game_request_or_to_play_again ??  "Yellow color indicates to accept/reject game request or to play again"
    }
    
    static func gameOrangeColor() -> String {
        return StringsManager.shared.orange_color_indicates_that_your_poke_game_request_is_pending ?? "Orange color indicates that your Poke Game request is pending"
    }
    
    static func gameAddPokeGameFriend() -> String {
        return StringsManager.shared.indicates_to_add_poke_game_friend ?? "Indicates to add Poke Game friend"
    }
    
    // MARK:- DAILY SIGN INFO -
    
    static func dailySignRedColor() -> String {
        return StringsManager.shared.red_color_indicates_you_sould_remember_to_give_dailysign ?? "Red color indicates you sould remember to give DailySign"
    }
    
    static func dailySignGreenColor() -> String {
        return StringsManager.shared.green_color_indicates_that_dailysign_is_successfull_send ?? "Green color indicates that DailySign is successfull send"
    }
    
    static func dailySignYellowColor() -> String {
        return StringsManager.shared.yellow_color_indicates_that_you_can_send_dailysign_30_minutes_before_the_current_dailysign_time ?? "Yellow color indicates that you can send DailySign 30 minutes before the current DailySign time"
    }
    
    static func dailySignOrangeColor() -> String {
        return StringsManager.shared.orange_color_indicates_that_you_are_waiting_for_dailysign_from_your_friend ?? "Orange color indicates that you are waiting for DailySign from your friend"
    }
    
    
    
    static func dailySignAddFriend() -> String {
        return StringsManager.shared.indicates_to_add_dailysign_friend ?? "Indicates to add DailySign friend"
    }
    
    // MARK:- SOS INFO -
    
    static func sosPushForThreeSec() -> String {
        return StringsManager.shared.sos_push_button_for_3_second_to_send_emergency_message ?? "SOS push button for 3 second to send emergency message"
    }
    
    static func sosSendTab() -> String {
        return StringsManager.shared.in_sos_listing_sos_sent_tab_shows_sos_sent_by_you ?? "In SOS listing SOS Sent tab shows SOS sent by you"
    }
    
    static func sosReceiveTab() -> String {
        return StringsManager.shared.in_sos_listing_sos_received_tab_shows_sos_to_you_by_your_friends ?? "In SOS listing SOS received tab shows SOS to you by your friends"
    }
    
    static func sosAvailableSMS() -> String {
        return StringsManager.shared.available_sms ?? "Available SMS"
    }
    
    static func playWitFriends() -> String {
        return StringsManager.shared.play_with_your_friends ?? "Play with your friends"
    }
    
    
    static func sosAddSOSNumber() -> String {
        return StringsManager.shared.add_sos_number ?? "Add SOS number"
    }
    
    static func DailySignInfo() -> String {
        return StringsManager.shared.dailysign_info ?? "DailySign Info"
    }
    static func getDeliveredString() -> String {
        return StringsManager.shared.delivered ?? "Delivered"
    }
    static func getSeenString() -> String {
        return StringsManager.shared.seen ?? "Seen"
    }
    
    static func getWriteMsgHereString() -> String {
        return StringsManager.shared.type_message_here ?? "Type message here..."
    }
    
    static func getOnlinString() -> String {
        return StringsManager.shared.online ?? "Online"
    }
    static func getOfflineString() -> String {
        return StringsManager.shared.offline ?? "Offline"
    }
    
    static func getWorldWideTop() -> String {
        return StringsManager.shared.worldwide_top_100 ?? "Worldwide top 100"
    }
    
    static func getMyFriendsString() -> String {
        return StringsManager.shared.my_friends ?? "Your Friends"
    }
    
    static func shareLifeSign() -> String {
        return StringsManager.shared.share_lifesign ?? "Share LifeSign"
    }
    
    static func getCongratsString() -> String {
        return StringsManager.shared.congratulations ?? "Congratulations"
    }
   
    static func getRewardSuccessString() -> String {
        return StringsManager.shared.you_have_been_rewarded_100_clicks ?? "You have been rewarded 1000 Auto Clicks"
    }

    static func get1000AutoClicksForFree() -> String {
        return StringsManager.shared.get_1000_free_auto_clicks ?? "Get 1000 free Auto Clicks"
    }

    static func getDownloadOurOtherApps() -> String {
        return StringsManager.shared.download_our_other_apps ?? "Download our other apps"
    }
    static func getDownloadAppsButtonText() -> String {
        return StringsManager.shared.download_other_apps ?? "Download other apps & Earn Reward"
    }
    
    
    static func getYourFriendsString() -> String {
        return StringsManager.shared.your_friends ?? ""
    }
    
    static func shareLifeSignOnSocialString() -> String {
        return StringsManager.shared.share_lifeSign_on_social_media ?? ""
    }
    
    static func addPhoneBookString() -> String {
        return StringsManager.shared.add_phone_book_friends ?? ""
    }
    
    static func addUnknownString() -> String {
        return StringsManager.shared.add_unknown_friends ?? ""
    }
    
    static func getReawardedClicks() -> String {
        return StringsManager.shared.you_have_been_rewarded_2_auto_clicks ?? "You have been rewarded 2 Auto Clicks"
    }
    static func getFreeSMSRewarded() -> String {
        return StringsManager.shared.you_have_been_rewarded_1_free_sms ?? "You have been rewarded 1 Free SMS"
    }
    
    static func appWillNotWorkOptimally() -> String {
        return StringsManager.shared.app_will_not_work_optimally ?? "App does not work optimally if the sound is muted"
    }
    
    static func getRemoveAdsInBottom() -> String {
        return StringsManager.shared.remove_ads_in_bottom ?? "Remove Ads in bottom"
    }
    static func getEightExtraSMS() -> String {
        return StringsManager.shared.eight_extra_sms ?? "8 Extra SMS"
    }
    static func getTwentyFiveExtraSMS() -> String {
        return StringsManager.shared.twenty_five_extra_sms ?? "25 Extra SMS"
    }
    static func getHundredExtraSMS() -> String {
        return StringsManager.shared.hundred_extra_sms ?? "100 Extra SMS"
    }
    static func msg_140_1_contact() -> String {
        return StringsManager.shared.msg_140_1_contact ?? "Messages over 140 characters for 1 contact"
    }
    static func msg_140_10_contact() -> String {
        return StringsManager.shared.msg_140_10_contact ?? "Messages over 140 characters for 10 contacts"
    }
    static func msg_140_unlimitted_contact() -> String {
        return StringsManager.shared.msg_140_unlimitted_contact ?? "Messages over 140 characters for unlimitted contacts"
    }
}



