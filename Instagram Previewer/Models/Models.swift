//
//  MediaData.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 21/10/2023.
//

import Foundation

struct Content: Codable {
    var data: [Media]
    var paging: Paging
    
    struct Paging: Codable {
        let cursors: Cursors
        
        struct Cursors: Codable {
            let before: String
            let after: String
        }
    }
}

struct Media: Codable {
    let media_url: String
    let timestamp: String
}

struct Profile: Codable {
    let access_token: String
    let user_id: Int
}

struct LongLivedToken: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
}

struct User: Codable {
    let id: String
    var username: String
    var media: [Data]
}

struct Info: Codable {
    let id: String
    let username: String
}





struct Welcome: Codable {
    let seoCategoryInfos: [[String]]
    let loggingPageID: String
    let showSuggestedProfiles: Bool
    let graphql: Graphql
    let toastContentOnLoad: JSONNull?
    let showQrModal, showViewShop: Bool

    enum CodingKeys: String, CodingKey {
        case seoCategoryInfos = "seo_category_infos"
        case loggingPageID = "logging_page_id"
        case showSuggestedProfiles = "show_suggested_profiles"
        case graphql
        case toastContentOnLoad = "toast_content_on_load"
        case showQrModal = "show_qr_modal"
        case showViewShop = "show_view_shop"
    }
}

// MARK: - Graphql
struct Graphql: Codable {
    let user: Userr
}

// MARK: - User
struct Userr: Codable {
    let aiAgentType: JSONNull?
    let biography: String
    let bioLinks: [JSONAny]
    let fbProfileBiolink: JSONNull?
    let biographyWithEntities: BiographyWithEntities
    let blockedByViewer, restrictedByViewer, countryBlock: Bool
    let eimuID: String
    let externalURL, externalURLLinkshimmed: JSONNull?
    let edgeFollowedBy: EdgeFollowClass
    let fbid: String
    let followedByViewer: Bool
    let edgeFollow: EdgeFollowClass
    let followsViewer: Bool
    let fullName: String
    let groupMetadata: JSONNull?
    let hasArEffects, hasClips, hasGuides, hasChannel: Bool
    let hasBlockedViewer: Bool
    let highlightReelCount: Int
    let hasRequestedViewer, hideLikeAndViewCounts: Bool
    let id: String
    let isBusinessAccount, isProfessionalAccount, isSupervisionEnabled, isGuardianOfViewer: Bool
    let isSupervisedByViewer, isSupervisedUser, isEmbedsDisabled, isJoinedRecently: Bool
    let guardianID, businessAddressJSON: JSONNull?
    let businessContactMethod: String
    let businessEmail, businessPhoneNumber, businessCategoryName, overallCategoryName: JSONNull?
    let categoryEnum, categoryName: JSONNull?
    let isPrivate, isVerified, isVerifiedByMv4B, isRegulatedC18: Bool
    let edgeMutualFollowedBy: EdgeMutualFollowedBy
    let pinnedChannelsListCount: Int
    let profilePicURL, profilePicURLHD: String
    let requestedByViewer, shouldShowCategory, shouldShowPublicContacts, showAccountTransparencyDetails: Bool
    let transparencyLabel: JSONNull?
    let transparencyProduct: String
    let username: Username
    let connectedFbPage: JSONNull?
    let pronouns: [JSONAny]
    let edgeFelixCombinedPostUploads, edgeFelixCombinedDraftUploads, edgeFelixVideoTimeline, edgeFelixDrafts: EdgeFelixCombinedDraftUploadsClass
    let edgeFelixPendingPostUploads, edgeFelixPendingDraftUploads, edgeOwnerToTimelineMedia, edgeSavedMedia: EdgeFelixCombinedDraftUploadsClass
    let edgeMediaCollections: EdgeFelixCombinedDraftUploadsClass

    enum CodingKeys: String, CodingKey {
        case aiAgentType = "ai_agent_type"
        case biography
        case bioLinks = "bio_links"
        case fbProfileBiolink = "fb_profile_biolink"
        case biographyWithEntities = "biography_with_entities"
        case blockedByViewer = "blocked_by_viewer"
        case restrictedByViewer = "restricted_by_viewer"
        case countryBlock = "country_block"
        case eimuID = "eimu_id"
        case externalURL = "external_url"
        case externalURLLinkshimmed = "external_url_linkshimmed"
        case edgeFollowedBy = "edge_followed_by"
        case fbid
        case followedByViewer = "followed_by_viewer"
        case edgeFollow = "edge_follow"
        case followsViewer = "follows_viewer"
        case fullName = "full_name"
        case groupMetadata = "group_metadata"
        case hasArEffects = "has_ar_effects"
        case hasClips = "has_clips"
        case hasGuides = "has_guides"
        case hasChannel = "has_channel"
        case hasBlockedViewer = "has_blocked_viewer"
        case highlightReelCount = "highlight_reel_count"
        case hasRequestedViewer = "has_requested_viewer"
        case hideLikeAndViewCounts = "hide_like_and_view_counts"
        case id
        case isBusinessAccount = "is_business_account"
        case isProfessionalAccount = "is_professional_account"
        case isSupervisionEnabled = "is_supervision_enabled"
        case isGuardianOfViewer = "is_guardian_of_viewer"
        case isSupervisedByViewer = "is_supervised_by_viewer"
        case isSupervisedUser = "is_supervised_user"
        case isEmbedsDisabled = "is_embeds_disabled"
        case isJoinedRecently = "is_joined_recently"
        case guardianID = "guardian_id"
        case businessAddressJSON = "business_address_json"
        case businessContactMethod = "business_contact_method"
        case businessEmail = "business_email"
        case businessPhoneNumber = "business_phone_number"
        case businessCategoryName = "business_category_name"
        case overallCategoryName = "overall_category_name"
        case categoryEnum = "category_enum"
        case categoryName = "category_name"
        case isPrivate = "is_private"
        case isVerified = "is_verified"
        case isVerifiedByMv4B = "is_verified_by_mv4b"
        case isRegulatedC18 = "is_regulated_c18"
        case edgeMutualFollowedBy = "edge_mutual_followed_by"
        case pinnedChannelsListCount = "pinned_channels_list_count"
        case profilePicURL = "profile_pic_url"
        case profilePicURLHD = "profile_pic_url_hd"
        case requestedByViewer = "requested_by_viewer"
        case shouldShowCategory = "should_show_category"
        case shouldShowPublicContacts = "should_show_public_contacts"
        case showAccountTransparencyDetails = "show_account_transparency_details"
        case transparencyLabel = "transparency_label"
        case transparencyProduct = "transparency_product"
        case username
        case connectedFbPage = "connected_fb_page"
        case pronouns
        case edgeFelixCombinedPostUploads = "edge_felix_combined_post_uploads"
        case edgeFelixCombinedDraftUploads = "edge_felix_combined_draft_uploads"
        case edgeFelixVideoTimeline = "edge_felix_video_timeline"
        case edgeFelixDrafts = "edge_felix_drafts"
        case edgeFelixPendingPostUploads = "edge_felix_pending_post_uploads"
        case edgeFelixPendingDraftUploads = "edge_felix_pending_draft_uploads"
        case edgeOwnerToTimelineMedia = "edge_owner_to_timeline_media"
        case edgeSavedMedia = "edge_saved_media"
        case edgeMediaCollections = "edge_media_collections"
    }
}

// MARK: - BiographyWithEntities
struct BiographyWithEntities: Codable {
    let rawText: String
    let entities: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case rawText = "raw_text"
        case entities
    }
}

// MARK: - EdgeFelixCombinedDraftUploadsClass
struct EdgeFelixCombinedDraftUploadsClass: Codable {
    let count: Int
    let pageInfo: PageInfo
    let edges: [Edge]

    enum CodingKeys: String, CodingKey {
        case count
        case pageInfo = "page_info"
        case edges
    }
}

// MARK: - Edge
struct Edge: Codable {
    let node: Node
}

// MARK: - Node
struct Node: Codable {
    let typename: Typename
    let id, shortcode: String
    let dimensions: Dimensions
    let displayURL: String
    let edgeMediaToTaggedUser: EdgeMediaTo
    let factCheckOverallRating, factCheckInformation, gatingInfo: JSONNull?
    let sharingFrictionInfo: SharingFrictionInfo
    let mediaOverlayInfo: JSONNull?
    let mediaPreview: String
    let owner: Owner
    let isVideo, hasUpcomingEvent: Bool
    let accessibilityCaption: String
    let edgeMediaToCaption: EdgeMediaTo
    let edgeMediaToComment: EdgeFollowClass
    let commentsDisabled: Bool
    let takenAtTimestamp: Int
    let edgeLikedBy, edgeMediaPreviewLike: EdgeFollowClass
    let location, nftAssetInfo: JSONNull?
    let thumbnailSrc: String
    let thumbnailResources: [ThumbnailResource]
    let coauthorProducers, pinnedForUsers: [JSONAny]
    let viewerCanReshare: Bool

    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
        case id, shortcode, dimensions
        case displayURL = "display_url"
        case edgeMediaToTaggedUser = "edge_media_to_tagged_user"
        case factCheckOverallRating = "fact_check_overall_rating"
        case factCheckInformation = "fact_check_information"
        case gatingInfo = "gating_info"
        case sharingFrictionInfo = "sharing_friction_info"
        case mediaOverlayInfo = "media_overlay_info"
        case mediaPreview = "media_preview"
        case owner
        case isVideo = "is_video"
        case hasUpcomingEvent = "has_upcoming_event"
        case accessibilityCaption = "accessibility_caption"
        case edgeMediaToCaption = "edge_media_to_caption"
        case edgeMediaToComment = "edge_media_to_comment"
        case commentsDisabled = "comments_disabled"
        case takenAtTimestamp = "taken_at_timestamp"
        case edgeLikedBy = "edge_liked_by"
        case edgeMediaPreviewLike = "edge_media_preview_like"
        case location
        case nftAssetInfo = "nft_asset_info"
        case thumbnailSrc = "thumbnail_src"
        case thumbnailResources = "thumbnail_resources"
        case coauthorProducers = "coauthor_producers"
        case pinnedForUsers = "pinned_for_users"
        case viewerCanReshare = "viewer_can_reshare"
    }
}

// MARK: - Dimensions
struct Dimensions: Codable {
    let height, width: Int
}

// MARK: - EdgeFollowClass
struct EdgeFollowClass: Codable {
    let count: Int
}

// MARK: - EdgeMediaTo
struct EdgeMediaTo: Codable {
    let edges: [JSONAny]
}

// MARK: - Owner
struct Owner: Codable {
    let id: String
    let username: Username
}

enum Username: String, Codable {
    case swApp1 = "sw.app1"
}

// MARK: - SharingFrictionInfo
struct SharingFrictionInfo: Codable {
    let shouldHaveSharingFriction: Bool
    let bloksAppURL: JSONNull?

    enum CodingKeys: String, CodingKey {
        case shouldHaveSharingFriction = "should_have_sharing_friction"
        case bloksAppURL = "bloks_app_url"
    }
}

// MARK: - ThumbnailResource
struct ThumbnailResource: Codable {
    let src: String
    let configWidth, configHeight: Int

    enum CodingKeys: String, CodingKey {
        case src
        case configWidth = "config_width"
        case configHeight = "config_height"
    }
}

enum Typename: String, Codable {
    case graphImage = "GraphImage"
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let hasNextPage: Bool
    let endCursor: String?

    enum CodingKeys: String, CodingKey {
        case hasNextPage = "has_next_page"
        case endCursor = "end_cursor"
    }
}

// MARK: - EdgeMutualFollowedBy
struct EdgeMutualFollowedBy: Codable {
    let count: Int
    let edges: [JSONAny]
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
