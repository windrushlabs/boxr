module Boxr
	class Client

		def current_user(fields: [])
			uri = "#{USERS_URI}/me"
			query = build_fields_query(fields, USER_FIELDS_QUERY)
			user, response = get(uri, query: query)
			user
		end

		def user(user_id, fields: [])
			uri = "#{USERS_URI}/#{user_id}"
			query = build_fields_query(fields, USER_FIELDS_QUERY)
			user, response = get(uri, query: query)
			user
		end

		def all_users(filter_term: nil, fields: [])
			uri = USERS_URI
			query = build_fields_query(fields, USER_FIELDS_QUERY)
			query[:filter_term] = filter_term unless filter_term.nil?
			users, response = get_with_pagination(uri, query: query)
		end

		def create_user(login, name, role: nil, language: nil, is_sync_enabled: nil, job_title: nil,
																 phone: nil, address: nil, space_amount: nil, tracking_codes: nil,
																 can_see_managed_users: nil, is_external_collab_restricted: nil, status: nil, timezone: nil,
																 is_exempt_from_device_limits: nil, is_exempt_from_login_verification: nil)

			uri = USERS_URI
			attributes = {login: login, name: name}
			attributes[:role] = role unless role.nil?
			attributes[:language] = language unless language.nil?
			attributes[:is_sync_enabled] = is_sync_enabled unless is_sync_enabled.nil?
			attributes[:job_title] = job_title unless job_title.nil?
			attributes[:phone] = phone unless phone.nil? 
			attributes[:address] = address unless address.nil?
			attributes[:space_amount] = space_amount unless space_amount.nil?
			attributes[:tracking_codes] = tracking_codes unless tracking_codes.nil?
			attributes[:can_see_managed_users] = can_see_managed_users unless can_see_managed_users.nil?
			attributes[:is_external_collab_restricted] = is_external_collab_restricted unless is_external_collab_restricted.nil?
			attributes[:status] = status unless status.nil?
			attributes[:timezone] = timezone unless timezone.nil?
			attributes[:is_exempt_from_device_limits] = is_exempt_from_device_limits unless is_exempt_from_device_limits.nil? 
			attributes[:is_exempt_from_login_verification] = is_exempt_from_login_verification unless is_exempt_from_login_verification.nil?

			new_user, response = post(uri, attributes)
			new_user
		end

		def update_user(user_id, notify: nil, enterprise: true, name: nil, role: nil, language: nil, is_sync_enabled: nil,
														 job_title: nil, phone: nil, address: nil, space_amount: nil, tracking_codes: nil,
														 can_see_managed_users: nil, status: nil, timezone: nil, is_exempt_from_device_limits: nil,
														 is_exempt_from_login_verification: nil, is_exempt_from_reset_required: nil, is_external_collab_restricted: nil)

			uri = "#{USERS_URI}/#{user_id}"
			query = {notify: notify} unless notify.nil?
			
			attributes = {}
			attributes[:enterprise] = nil if enterprise.nil? #this is a special condition where setting this to nil means to roll this user out of the enterprise 
			attributes[:name] = name unless name.nil?
			attributes[:role] = role unless role.nil?
			attributes[:language] = language unless language.nil?
			attributes[:is_sync_enabled] = is_sync_enabled unless is_sync_enabled.nil?
			attributes[:job_title] = job_title unless job_title.nil?
			attributes[:phone] = phone unless phone.nil?
			attributes[:address] = address unless address.nil?
			attributes[:space_amount] = space_amount unless space_amount.nil?
			attributes[:tracking_codes] = tracking_codes unless tracking_codes.nil?
			attributes[:can_see_managed_users] = can_see_managed_users unless can_see_managed_users.nil?
			attributes[:status] = status unless status.nil?
			attributes[:timezone] = timezone unless timezone.nil?
			attributes[:is_exempt_from_device_limits] = is_exempt_from_device_limits unless is_exempt_from_device_limits.nil?
			attributes[:is_exempt_from_login_verification] = is_exempt_from_login_verification unless is_exempt_from_login_verification.nil?
			attributes[:is_exempt_from_reset_required] = is_exempt_from_reset_required unless is_exempt_from_reset_required.nil?
			attributes[:is_external_collab_restricted] = is_external_collab_restricted unless is_external_collab_restricted.nil?

			updated_user, response = put(uri, attributes, query: query)
			updated_user
		end

		def delete_user(user_id, notify: nil, force: nil)
			uri = "#{USERS_URI}/#{user_id}"
			query = {}
			query[:notify] = notify unless notify.nil?
			query[:force] = force unless force.nil?
			result, response = delete(uri, query: query)
			result
		end

	end
end