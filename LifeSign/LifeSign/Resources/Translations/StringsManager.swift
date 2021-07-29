//
//  StringsManager.swift
//  2Again
//
//  Created by APPLE on 6/16/21.
//  Copyright © 2021 SoftwareAlliance. All rights reserved.
//

import Foundation
import ObjectMapper


class StringsManager: Mappable {
    
    ///
    // MARK:- AuthBoard -
    ///
    var back : String?
    var search : String?
    var you : String?
    var unlimited : String?
    var request_pending : String?
    var request_sent : String?
    var accept : String?
    var reject : String?
    var no_record_found : String?
    var done : String?
    var error : String?
    var unable_to_login_with_facebook_this_time : String?
    var you_have_declined_login_permission : String?
    var alert : String?
    var you_are_not_subscribed_to_send_message_over_140_characters_please_buy_message_package : String?
    var you_have_no_more_free_dailysign_contacts_available : String?
    var you_dont_have_any_sos_friend_would_you_like_to_add_new_sos_friend : String?
    var has_been_notified_successfully : String?
    var all_fields_are_required : String?
    var password_and_confirm_password_should_be_same : String?
    var new_password_and_confirm_password_should_be_same : String?
    var ok : String?
    var email_address : String?
    var app_will_not_work: String?
    var password : String?
    var old_password : String?
    var confirm_password : String?
    var network_not_available : String?
    var something_went_wrong : String?
    var new_password : String?
    var send : String?
    var cancel : String?
    var open_settings : String?
    var lifesign_app_requires_access_to_contacts_to_proceed_go_to_settings_to_grant_access : String?
    var delete_conversation : String?
    var invalid_email : String?
    var your_email_address_is_not_valid : String?
    var password_length_must_be_minimum_of_6_characters : String?
    var next : String?
    var sign_up : String?
    var success : String?
    var code_resent_successfully : String?
    var all_purchases_restored: String?
    var your_transaction_have_been_stored_successfully : String?
    var remind : String?
    var oksign_friends : String?
    var im_ok : String?
    var oksign : String?
    var check_friends : String?
    var lifesign_friends : String?
    var friend_request : String?
    var tell_friends : String?
    var an_easy_way_to_let_your_loved_ones_know_you_are_ok : String?
    var add_and_find_your_friends_via_oksign : String?
    var check_your_friends_medical_condition_that_they_are_ok_or_not : String?
    var tell_your_friends_about_your_medical_condition_that_is_ok_or_not : String?
    var use_this_functionality_every_1_hour : String? = "Use this functionality every 1 hour"
    var send_as_needed_or_ask_okSign: String?
    var check_if_reached_safe_on_their_dest: String? = "Check if they reached safe on their destination"
    var emergency_help_needed : String?
    var reset : String?
    var just_hold_the_button_for_3_sec : String?
    var push_this_for_3_sec : String?
    var sos_sent : String?
    var sos_received : String?
    var see_all : String?
    var sos : String?
    var tabb_shop: String?
    var sos_listing : String?
    var add_new : String?
    var add_now : String?
    var if_you_are_in_emergency_conditionsend_request : String?
    var add_and_find_your_friends_via_sos : String?
    var send_and_received_sos_in_an_emergency_condition : String?
    var you_can_add_more_friends_just_in_case : String?
    var wait_for_your_friends_to_come_and_help_you_or_your_friends_are_waiting_for_you_to_come_and_help : String?
    var use_this_functionality_anytime_when_you_want : String?
    var dailysign : String?
    var who_is_going_to_send_dailysign : String?
    var keep_connecting_with_your_friends_and_live_every_day : String?
    var add_and_find_your_new_friends_via_dailysign : String?
    var set_the_timewhen_you_want_to_receive_dailysign_to_your_friends : String?
    var every_day_you_will_receive_a_dailysign_alert_from_your_friends : String?
    var every_day_you_can_send_dailysign_alert_to_your_friends : String?
    var seen : String?
    var not_seen : String?
    var marked_seen : String?
    var got_it : String?
    var friends : String?
    var new_chat : String?
    var friends_you_dont_know : String?
    var are_you_lonely_or_do_you_just_want_new_friends_arounds_the_world : String?
    var go_to_friends_page_and_tap_on_add_icon : String?
    var choose_between_locally_nationally_and_the_internationally_for_new_friendsyou_want_to_find : String?
    var send_friend_request_by_click_on_the_add_button : String?
    var when_you_are_friends_you_can_add_them_to_poke_game_or_chat_and_get_to_know_each_other : String?
    var services : String?
    var poke_games : String?
    var easy_way_to_be_top_of_mind_with_your_family_or_loved_one : String?
    var tap_on_the_poke_game_icon : String?
    var then_tap_on_the_yellow_button_to_add_friends : String?
    var tap_on_the_name_to_send_a_game_request : String?
    var play_with_your_friends_until_one_of_you_does_not_have_tie_to_poke_and_get_on_there_hits_list : String?
    var please_select_your_language : String?
    var welcome_to_lifesign : String?
    var sign_in_with_apple : String?
    var login_with_facebook : String?
    var login : String?
    var are_you_a_new_user : String?
    var register_new_account : String?
    var login_to_your_account : String?
    var remember_me : String?
    var forgot_password : String?
    var eg_johndoecom : String?
    var register : String?
    var reset_password : String?
    var change_password : String?
    var enter_your_email_address : String?
    var register_your_account_now : String?
    var full_name : String?
    var i_accept_the_terms_and_conditions : String?
    var i_give_my_consent_to_lifesign : String?
    var already_have_an_account : String?
    var we_need_few_more_details : String?
    var contact_number : String?
    var select_time_zone : String?
    var zip_code : String?
    var otp_verification : String?
    var verification_code : String?
    var a_verification_code_has_been_sent_to_your_email : String?
    var did_not_received_the_code : String?
    var resend : String?
    var password_updated_successfully_please_login_to_your_account : String?
    var password_updated_successfully : String?
    var sos_number_added_successfully : String?
    var add : String?
    var view_more : String?
    var view_request : String?
    var invite : String?
    var invitation_received : String?
    var invitation_sent : String?
    var cancel_request : String?
    var my_friends : String?
    var request_sent_successfully : String?
    var unable_to_send_request_this_time : String?
    var unable_to_accept_request_this_time : String?
    var unable_to_reject_request_this_time : String?
    var people : String?
    var invite_friends : String?
    var local : String?
    var international : String?
    var national : String?
    var add_in_sos_friends_list : String?
    var added : String?
    var not_added : String?
    var send_message : String?
    var add_in_lifesign_friends_list : String?
    var add_in_ok_friends_list : String?
    var add_in_health_friends_list : String?
    var health: String?
    var block : String?
    var delete : String?
    var read : String?
    var remove : String?
    var notifications : String?
    var profile : String?
    var connect_watch : String?
    var stranger_request : String?
    var blocked_users : String?
    var logout : String?
    var edit_profile : String?
    var change_profile_image : String?
    var first_name : String?
    var last_name : String?
    var save : String?
    var buy_sms : String?
    var buy : String?
    var you_must_accept_our_terms_and_conditions : String?
    var buy_messages_package : String?
    var buy_more_contacts : String?
    var go_to_friends : String?
    var change : String?
    var messages : String?
    var settings : String?
    var leaderboard : String?
    var unblock : String?
    var faqs : String?
    var only_in_english_and_danish : String?
    var dont_want_friend_requests_from_strangers : String?
    var sound_onoff : String?
    var link_for_terms_and_conditions : String?
    var download_gdpr_info : String?
    var delete_profile : String?
    var mobile_number_to_receive_sos_sms_and_lifesign_sms_warning : String?
    var are_you_sure : String?
    var do_you_want_to_delete_your_account : String?
    var edit_nick_name : String?
    var edit_lifesign_time : String?
    var share_lifesign : String?
    var swap_lifesign : String?
    var remove_from_lifesign : String?
    var hi_lets_signup_for_the_lifesign_app_https : String?
    var watch_video__earn_2_free_autoclicks : String?
    var watch_video__earn_1_free_sms : String?
    var extra_dailysign_contacts_available : String?
    var what_i_have_available: String?
    var extra_clicks_available : String?
    var extra_poke_games_available : String?
    var remove_ads_in_bottom : String? = "Remove Ads in bottom"
    var available_contacts_to_send_140_plus_characters_message : String?
    var available_sms : String?
    var awaiting_dailysign : String?
    var send_dailysign : String?
    var buy_more : String?
    var opponent_turn : String?
    var your_turn : String?
    var auto_clicks : String?
    var buy_more_games : String?
    var current_status : String?
    var game_points : String?
    var you_have : String?
    var free_games : String?
    var friend_info : String?
    var share_lifeSign_on_social_media : String?
    var add_phone_book_friends : String?
    var add_unknown_friends : String?
    var play_again : String?
    var do_you_want_to_remove_your_poke_game_friend_re_add_will_take_1_extra_game : String?
    var yes : String?
    var no : String?
    var send_invitation : String?
    var you_won : String?
    var you_loss : String?
    var game_friend_invited : String?
    var wants_to_play_game : String?
    var game_friend_invitation : String?
    var play_game : String?
    var how_to_use_function : String?
    var poke_game_info : String?
    var sos_info : String?
    var friends_info : String?
    var red_color_indicates_to_invite_a_friend_to_play_poke_game : String?
    var green_color_indicates_that_your_poke_game_is_in_progress : String?
    var yellow_color_indicates_to_acceptreject_game_request_or_to_play_again : String?
    var orange_color_indicates_that_your_poke_game_request_is_pending : String?
    var indicates_to_add_poke_game_friend : String?
    var red_color_indicates_you_sould_remember_to_give_dailysign : String?
    var green_color_indicates_that_dailysign_is_successfull_send : String?
    var yellow_color_indicates_that_you_can_send_dailysign_30_minutes_before_the_current_dailysign_time : String?
    var orange_color_indicates_that_you_are_waiting_for_dailysign_from_your_friend : String?
    var indicates_to_add_dailysign_friend : String?
    var sos_push_button_for_3_second_to_send_emergency_message : String?
    var in_sos_listing_sos_sent_tab_shows_sos_sent_by_you : String?
    var in_sos_listing_sos_received_tab_shows_sos_to_you_by_your_friends : String?
    var play_with_your_friends : String?
    var one_point_to_start_game: String?
    var three_point_to_start_game: String?
    var ten_point_to_start_game: String?
    var add_sos_number : String?
    var dailysign_info : String?
    var delivered : String?
    var type_message_here : String?
    var online : String?
    var offline : String?
    var worldwide_top_100 : String?
    var your_friends : String?
    var congratulations : String?
    var you_have_been_rewarded_2_auto_clicks : String?
    var you_have_been_rewarded_1_free_sms : String?
    var restore_purchase: String?
    var app_will_not_work_optimally : String?
    var eight_extra_sms : String?
    var twenty_five_extra_sms : String?
    var hundred_extra_sms : String?
    var msg_140_1_contact : String?
    var msg_140_10_contact : String?
    var msg_140_unlimitted_contact : String?
    var unli_ext_poke_games : String?
    var ten_ext_poke_games : String?
    var two_ext_poke_games : String?
    var five_hun_auto_clicks : String?
    var thousand_auto_clicks : String?
    var unlimited_extra_contacts : String?
    var twenty_hund_auto_clicks : String?
    var two_hund_auto_clicks : String?
    var five_thousand_auto_clicks : String?
    var two_extra_contacts : String?
    var ten_extra_contacts : String?
    var download_other_apps: String?
    var download_our_other_apps: String?
    var get_1000_free_auto_clicks: String?
    var you_have_been_rewarded_100_clicks: String?
    var switch_on: String?
    var switch_off: String?
    
    
    static let shared = StringsManager()
    
    init() {
        
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
    convenience init(dic:[String:Any]) {
        let map = Map.init(mappingType: .fromJSON, JSON: dic)
        self.init(map:map)!
    }
    
    func deleteStrings() {
        
        saveStrings(strings: self)
    }
    
    func loadStrings() {
        let userDef = UserDefaults.standard
        if ((userDef.string(forKey: Constants.STRINGS_DATA)) != nil) {
            let uString = UserDefaults.standard.value(forKey: Constants.STRINGS_DATA) as! String
            let mapper = Mapper<StringsManager>()
            let userObj = mapper.map(JSONString: uString)
            let map = Map.init(mappingType: .fromJSON, JSON: (userObj?.toJSON())!)
            self.mapping(map:map)
        }
        NotificationCenter.default.post(name: .languageCanged, object: nil)
    }
    
    func saveStrings(strings: StringsManager) {
        UserDefaults.standard.set(strings.toJSONString()!, forKey: Constants.STRINGS_DATA)
        UserDefaults.standard.synchronize()
        loadStrings()
    }
    
    func mapping(map: Map) {
        back <- map["Back"]
        search <- map["search"]
        you <- map["you"]
        request_pending <- map["request_pending"]
        request_sent <- map["request_sent"]
        accept <- map["accept"]
        reject <- map["reject"]
        no_record_found <- map["no_record_found"]
        done <- map["done"]
        error <- map["error"]
        unable_to_login_with_facebook_this_time <- map["unable_to_login_with_facebook_this_time"]
        you_have_declined_login_permission <- map["you_have_declined_login_permission"]
        alert <- map["alert"]
        you_are_not_subscribed_to_send_message_over_140_characters_please_buy_message_package <- map["you_are_not_subscribed_to_send_message_over_140_characters_please_buy_message_package"]
        you_have_no_more_free_dailysign_contacts_available <- map["you_have_no_more_free_dailysign_contacts_available"]
        you_dont_have_any_sos_friend_would_you_like_to_add_new_sos_friend <- map["you_dont_have_any_sos_friend_would_you_like_to_add_new_sos_friend"]
        has_been_notified_successfully <- map["has_been_notified_successfully"]
        all_fields_are_required <- map["all_fields_are_required"]
        password_and_confirm_password_should_be_same <- map["password_and_confirm_password_should_be_same"]
        new_password_and_confirm_password_should_be_same <- map["new_password_and_confirm_password_should_be_same"]
        ok <- map["ok"]
        what_i_have_available <- map["what_i_have_available"]
        email_address <- map["email_address"]
        password <- map["password"]
        old_password <- map["old_password"]
        confirm_password <- map["confirm_password"]
        network_not_available <- map["network_not_available"]
        something_went_wrong <- map["something_went_wrong"]
        new_password <- map["new_password"]
        send <- map["send"]
        cancel <- map["cancel"]
        open_settings <- map["open_settings"]
        lifesign_app_requires_access_to_contacts_to_proceed_go_to_settings_to_grant_access <- map["lifesign_app_requires_access_to_contacts_to_proceed_go_to_settings_to_grant_access"]
        delete_conversation <- map["delete_conversation"]
        invalid_email <- map["invalid_email"]
        your_email_address_is_not_valid <- map["your_email_address_is_not_valid"]
        password_length_must_be_minimum_of_6_characters <- map["password_length_must_be_minimum_of_6_characters"]
        next <- map["next"]
        sign_up <- map["sign_up"]
        all_purchases_restored <- map["all_purchases_restored"]
        success <- map["success"]
        code_resent_successfully <- map["code_resent_successfully"]
        your_transaction_have_been_stored_successfully <- map["your_transaction_have_been_stored_successfully"]
        remind <- map["remind"]
        health <- map["health"]
        oksign_friends <- map["oksign_friends"]
        im_ok <- map["im_ok"]
        unlimited <- map["unlimited"]
        oksign <- map["oksign"]
        check_friends <- map["check_friends"]
        lifesign_friends <- map["lifesign_friends"]
        friend_request <- map["friend_request"]
        tell_friends <- map["tell_friends"]
        restore_purchase <- map["restore_purchase"]
        an_easy_way_to_let_your_loved_ones_know_you_are_ok <- map["an_easy_way_to_let_your_loved_ones_know_you_are_ok"]
        add_and_find_your_friends_via_oksign <- map["add_and_find_your_friends_via_oksign"]
        check_your_friends_medical_condition_that_they_are_ok_or_not <- map["check_your_friends_medical_condition_that_they_are_ok_or_not"]
        tell_your_friends_about_your_medical_condition_that_is_ok_or_not <- map["tell_your_friends_about_your_medical_condition_that_is_ok_or_not"]
        use_this_functionality_every_1_hour <- map["use_this_functionality_every_1_hour"]
        emergency_help_needed <- map["emergency_help_needed"]
        reset <- map["reset"]
        just_hold_the_button_for_3_sec <- map["just_hold_the_button_for_3_sec"]
        push_this_for_3_sec <- map["push_this_for_3_sec"]
        sos_sent <- map["sos_sent"]
        sos_received <- map["sos_received"]
        see_all <- map["see_all"]
        sos <- map["sos"]
        check_if_reached_safe_on_their_dest <- map["check_if_reached_safe_on_their_dest"]
        sos_listing <- map["sos_listing"]
        add_new <- map["add_new"]
        add_now <- map["add_now"]
        if_you_are_in_emergency_conditionsend_request <- map["if_you_are_in_emergency_conditionsend_request"]
        add_and_find_your_friends_via_sos <- map["add_and_find_your_friends_via_sos"]
        send_and_received_sos_in_an_emergency_condition <- map["send_and_received_sos_in_an_emergency_condition"]
        you_can_add_more_friends_just_in_case <- map["you_can_add_more_friends_just_in_case"]
        wait_for_your_friends_to_come_and_help_you_or_your_friends_are_waiting_for_you_to_come_and_help <- map["wait_for_your_friends_to_come_and_help_you_or_your_friends_are_waiting_for_you_to_come_and_help"]
        use_this_functionality_anytime_when_you_want <- map["use_this_functionality_anytime_when_you_want"]
        dailysign <- map["dailysign"]
        who_is_going_to_send_dailysign <- map["who_is_going_to_send_dailysign"]
        keep_connecting_with_your_friends_and_live_every_day <- map["keep_connecting_with_your_friends_and_live_every_day"]
        add_and_find_your_new_friends_via_dailysign <- map["add_and_find_your_new_friends_via_dailysign"]
        set_the_timewhen_you_want_to_receive_dailysign_to_your_friends <- map["set_the_timewhen_you_want_to_receive_dailysign_to_your_friends"]
        every_day_you_will_receive_a_dailysign_alert_from_your_friends <- map["every_day_you_will_receive_a_dailysign_alert_from_your_friends"]
        every_day_you_can_send_dailysign_alert_to_your_friends <- map["every_day_you_can_send_dailysign_alert_to_your_friends"]
        seen <- map["seen"]
        tabb_shop <- map["tabb_shop"]
        not_seen <- map["not_seen"]
        marked_seen <- map["marked_seen"]
        got_it <- map["got_it"]
        friends <- map["friends"]
        new_chat <- map["new_chat"]
        friends_you_dont_know <- map["friends_you_dont_know"]
        are_you_lonely_or_do_you_just_want_new_friends_arounds_the_world <- map["are_you_lonely_or_do_you_just_want_new_friends_arounds_the_world"]
        go_to_friends_page_and_tap_on_add_icon <- map["go_to_friends_page_and_tap_on_add_icon"]
        choose_between_locally_nationally_and_the_internationally_for_new_friendsyou_want_to_find <- map["choose_between_locally_nationally_and_the_internationally_for_new_friendsyou_want_to_find"]
        send_friend_request_by_click_on_the_add_button <- map["send_friend_request_by_click_on_the_add_button"]
        when_you_are_friends_you_can_add_them_to_poke_game_or_chat_and_get_to_know_each_other <- map["when_you_are_friends_you_can_add_them_to_poke_game_or_chat_and_get_to_know_each_other"]
        services <- map["services"]
        poke_games <- map["poke_games"]
        easy_way_to_be_top_of_mind_with_your_family_or_loved_one <- map["easy_way_to_be_top_of_mind_with_your_family_or_loved_one"]
        tap_on_the_poke_game_icon <- map["tap_on_the_poke_game_icon"]
        then_tap_on_the_yellow_button_to_add_friends <- map["then_tap_on_the_yellow_button_to_add_friends"]
        tap_on_the_name_to_send_a_game_request <- map["tap_on_the_name_to_send_a_game_request"]
        play_with_your_friends_until_one_of_you_does_not_have_tie_to_poke_and_get_on_there_hits_list <- map["play_with_your_friends_until_one_of_you_does_not_have_tie_to_poke_and_get_on_there_hits_list"]
        please_select_your_language <- map["please_select_your_language"]
        welcome_to_lifesign <- map["welcome_to_lifesign"]
        sign_in_with_apple <- map["sign_in_with_apple"]
        login_with_facebook <- map["login_with_facebook"]
        login <- map["login"]
        are_you_a_new_user <- map["are_you_a_new_user"]
        register_new_account <- map["register_new_account"]
        login_to_your_account <- map["login_to_your_account"]
        remember_me <- map["remember_me"]
        forgot_password <- map["forgot_password"]
        eg_johndoecom <- map["eg_johndoecom"]
        register <- map["register"]
        reset_password <- map["reset_password"]
        change_password <- map["change_password"]
        enter_your_email_address <- map["enter_your_email_address"]
        register_your_account_now <- map["register_your_account_now"]
        full_name <- map["full_name"]
        i_accept_the_terms_and_conditions <- map["i_accept_the_terms_and_conditions"]
        i_give_my_consent_to_lifesign <- map["i_give_my_consent_to_lifesign"]
        already_have_an_account <- map["already_have_an_account"]
        we_need_few_more_details <- map["we_need_few_more_details"]
        contact_number <- map["contact_number"]
        select_time_zone <- map["select_time_zone"]
        zip_code <- map["zip_code"]
        otp_verification <- map["otp_verification"]
        verification_code <- map["verification_code"]
        a_verification_code_has_been_sent_to_your_email <- map["a_verification_code_has_been_sent_to_your_email"]
        did_not_received_the_code <- map["did_not_received_the_code"]
        resend <- map["resend"]
        password_updated_successfully_please_login_to_your_account <- map["password_updated_successfully_please_login_to_your_account"]
        password_updated_successfully <- map["password_updated_successfully"]
        sos_number_added_successfully <- map["sos_number_added_successfully"]
        add <- map["add"]
        view_more <- map["view_more"]
        view_request <- map["view_request"]
        invite <- map["invite"]
        invitation_received <- map["invitation_received"]
        invitation_sent <- map["invitation_sent"]
        cancel_request <- map["cancel_request"]
        my_friends <- map["my_friends"]
        send_as_needed_or_ask_okSign <- map["send_as_needed_or_ask_okSign"]
        request_sent_successfully <- map["request_sent_successfully"]
        unable_to_send_request_this_time <- map["unable_to_send_request_this_time"]
        unable_to_accept_request_this_time <- map["unable_to_accept_request_this_time"]
        unable_to_reject_request_this_time <- map["unable_to_reject_request_this_time"]
        people <- map["people"]
        invite_friends <- map["invite_friends"]
        local <- map["local"]
        international <- map["international"]
        national <- map["national"]
        add_in_sos_friends_list <- map["add_in_sos_friends_list"]
        added <- map["added"]
        not_added <- map["not_added"]
        send_message <- map["send_message"]
        add_in_lifesign_friends_list <- map["add_in_lifesign_friends_list"]
        add_in_ok_friends_list <- map["add_in_ok_friends_list"]
        add_in_health_friends_list <- map["add_in_health_friends_list"]
        block <- map["block"]
        delete <- map["delete"]
        read <- map["read"]
        remove <- map["remove"]
        notifications <- map["notifications"]
        profile <- map["profile"]
        connect_watch <- map["connect_watch"]
        stranger_request <- map["stranger_request"]
        blocked_users <- map["blocked_users"]
        logout <- map["logout"]
        edit_profile <- map["edit_profile"]
        change_profile_image <- map["change_profile_image"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        save <- map["save"]
        buy_sms <- map["buy_sms"]
        buy <- map["buy"]
        you_must_accept_our_terms_and_conditions <- map["you_must_accept_our_terms_and_conditions"]
        buy_messages_package <- map["buy_messages_package"]
        buy_more_contacts <- map["buy_more_contacts"]
        go_to_friends <- map["go_to_friends"]
        change <- map["change"]
        messages <- map["messages"]
        settings <- map["settings"]
        leaderboard <- map["leaderboard"]
        unblock <- map["unblock"]
        faqs <- map["faqs"]
        only_in_english_and_danish <- map["only_in_english_and_danish"]
        dont_want_friend_requests_from_strangers <- map["dont_want_friend_requests_from_strangers"]
        sound_onoff <- map["sound_onoff"]
        link_for_terms_and_conditions <- map["link_for_terms_and_conditions"]
        download_gdpr_info <- map["download_gdpr_info"]
        delete_profile <- map["delete_profile"]
        mobile_number_to_receive_sos_sms_and_lifesign_sms_warning <- map["mobile_number_to_receive_sos_sms_and_lifesign_sms_warning"]
        are_you_sure <- map["are_you_sure"]
        do_you_want_to_delete_your_account <- map["do_you_want_to_delete_your_account"]
        edit_nick_name <- map["edit_nick_name"]
        edit_lifesign_time <- map["edit_lifesign_time"]
        share_lifesign <- map["share_lifesign"]
        swap_lifesign <- map["swap_lifesign"]
        remove_from_lifesign <- map["remove_from_lifesign"]
        hi_lets_signup_for_the_lifesign_app_https <- map["hi_lets_signup_for_the_lifesign_app_https:appsapplecomusapplifesignid1499793115"]
        watch_video__earn_2_free_autoclicks <- map["watch_video__earn_2_free_autoclicks"]
        watch_video__earn_1_free_sms <- map["watch_video__earn_1_free_sms"]
        extra_dailysign_contacts_available <- map["extra_dailysign_contacts_available"]
        extra_clicks_available <- map["extra_clicks_available"]
        extra_poke_games_available <- map["extra_poke_games_available"]
        remove_ads_in_bottom <- map["remove_ads_in_bottom"]
        available_contacts_to_send_140_plus_characters_message <- map["available_contacts_to_send_140_plus_characters_message"]
        available_sms <- map["available_sms"]
        awaiting_dailysign <- map["awaiting_dailysign"]
        send_dailysign <- map["send_dailysign"]
        buy_more <- map["buy_more"]
        opponent_turn <- map["opponent_turn"]
        your_turn <- map["your_turn"]
        auto_clicks <- map["auto_clicks"]
        buy_more_games <- map["buy_more_games"]
        current_status <- map["current_status"]
        game_points <- map["game_points"]
        you_have <- map["you_have"]
        app_will_not_work <- map["app_will_not_work"]
        free_games <- map["free_games"]
        play_again <- map["play_again"]
        do_you_want_to_remove_your_poke_game_friend_re_add_will_take_1_extra_game <- map["do_you_want_to_remove_your_poke_game_friend_re_add_will_take_1_extra_game"]
        yes <- map["yes"]
        no <- map["no"]
        send_invitation <- map["send_invitation"]
        you_won <- map["you_won"]
        you_loss <- map["you_loss"]
        game_friend_invited <- map["game_friend_invited"]
        wants_to_play_game <- map["wants_to_play_game"]
        game_friend_invitation <- map["game_friend_invitation"]
        play_game <- map["play_game"]
        how_to_use_function <- map["how_to_use_function"]
        poke_game_info <- map["poke_game_info"]
        sos_info <- map["sos_info"]
        friends_info <- map["friends_info"]
        red_color_indicates_to_invite_a_friend_to_play_poke_game <- map["red_color_indicates_to_invite_a_friend_to_play_poke_game"]
        green_color_indicates_that_your_poke_game_is_in_progress <- map["green_color_indicates_that_your_poke_game_is_in_progress"]
        yellow_color_indicates_to_acceptreject_game_request_or_to_play_again <- map["yellow_color_indicates_to_acceptreject_game_request_or_to_play_again"]
        orange_color_indicates_that_your_poke_game_request_is_pending <- map["orange_color_indicates_that_your_poke_game_request_is_pending"]
        indicates_to_add_poke_game_friend <- map["indicates_to_add_poke_game_friend"]
        red_color_indicates_you_sould_remember_to_give_dailysign <- map["red_color_indicates_you_sould_remember_to_give_dailysign"]
        green_color_indicates_that_dailysign_is_successfull_send <- map["green_color_indicates_that_dailysign_is_successfull_send"]
        yellow_color_indicates_that_you_can_send_dailysign_30_minutes_before_the_current_dailysign_time <- map["yellow_color_indicates_that_you_can_send_dailysign_30_minutes_before_the_current_dailysign_time"]
        orange_color_indicates_that_you_are_waiting_for_dailysign_from_your_friend <- map["orange_color_indicates_that_you_are_waiting_for_dailysign_from_your_friend"]
        indicates_to_add_dailysign_friend <- map["indicates_to_add_dailysign_friend"]
        sos_push_button_for_3_second_to_send_emergency_message <- map["sos_push_button_for_3_second_to_send_emergency_message"]
        in_sos_listing_sos_sent_tab_shows_sos_sent_by_you <- map["in_sos_listing_sos_sent_tab_shows_sos_sent_by_you"]
        in_sos_listing_sos_received_tab_shows_sos_to_you_by_your_friends <- map["in_sos_listing_sos_received_tab_shows_sos_to_you_by_your_friends"]
        play_with_your_friends <- map["play_with_your_friends"]
        add_sos_number <- map["add_sos_number"]
        dailysign_info <- map["dailysign_info"]
        delivered <- map["delivered"]
        type_message_here <- map["type_message_here…"]
        online <- map["online"]
        offline <- map["offline"]
        worldwide_top_100 <- map["worldwide_top_100"]
        your_friends <- map["your_friends"]
        congratulations <- map["congratulations"]
        you_have_been_rewarded_2_auto_clicks <- map["you_have_been_rewarded_2_auto_clicks"]
        you_have_been_rewarded_1_free_sms <- map["you_have_been_rewarded_1_free_sms"]
        app_will_not_work_optimally <- map["app_will_not_work_optimally"]
        eight_extra_sms <- map["eight_extra_sms"]
        twenty_five_extra_sms <- map["twenty_five_extra_sms"]
        hundred_extra_sms <- map["hundred_extra_sms"]
        msg_140_1_contact <- map["msg_140_1_contact"]
        msg_140_10_contact <- map["msg_140_10_contact"]
        msg_140_unlimitted_contact <- map["msg_140_unlimitted_contact"]
        unli_ext_poke_games <- map["unli_ext_poke_games"]
        ten_ext_poke_games <- map["ten_ext_poke_games"]
        two_ext_poke_games <- map["two_ext_poke_games"]
        five_hun_auto_clicks <- map["five_hun_auto_clicks"]
        thousand_auto_clicks <- map["thousand_auto_clicks"]
        unlimited_extra_contacts <- map["unlimited_extra_contacts"]
        twenty_hund_auto_clicks <- map["twenty_hund_auto_clicks"]
        two_hund_auto_clicks <- map["two_hund_auto_clicks"]
        five_thousand_auto_clicks <- map["five_thousand_auto_clicks"]
        two_extra_contacts <- map["two_extra_contacts"]
        ten_extra_contacts <- map["ten_extra_contacts"]
        
        one_point_to_start_game <- map["one_point_to_start_game"]
        three_point_to_start_game <- map["three_point_to_start_game"]
        ten_point_to_start_game <- map["ten_point_to_start_game"]
        
        friend_info <- map["friend_info"]
        share_lifeSign_on_social_media <- map["share_lifeSign_on_social_media"]
        add_phone_book_friends <- map["add_phone_book_friends"]
        add_unknown_friends <- map["add_unknown_friends"]
        
        download_other_apps <- map["download_other_apps"]
        download_our_other_apps <- map["download_our_other_apps"]
        get_1000_free_auto_clicks <- map["get_1000_free_auto_clicks"]
        you_have_been_rewarded_100_clicks <- map["you_have_been_rewarded_100_clicks"]
        
        switch_on <- map["switch_on"]
        switch_off <- map["switch_off"]
    }
}
