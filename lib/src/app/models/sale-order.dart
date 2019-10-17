class SaleOrder {
  String sLastUpdate;
  dynamic accessToken;
  String accessUrl;
  String accessWarning;
  dynamic activityDateDeadline;
  List<dynamic> activityIds;
  dynamic activityState;
  dynamic activitySummary;
  dynamic activityTypeId;
  dynamic activityUserId;
  List<dynamic> amountByGroup;
  int amountDelivery;
  int amountTax;
  int amountTotal;
  int amountUndiscounted;
  int amountUntaxed;
  dynamic analyticAccountId;
  List<dynamic> authorizedTransactionIds;
  List<dynamic> availableCarrierIds;
  dynamic carrierId;
  int cartQuantity;
  dynamic cartRecoveryEmailSent;
  dynamic clientOrderRef;
  dynamic commitmentDate;
  List<dynamic> companyId;
  dynamic confirmationDate;
  String createDate;
  List<dynamic> createUid;
  List<dynamic> currencyId;
  int currencyRate;
  String dateOrder;
  int deliveryCount;
  dynamic deliveryMessage;
  int deliveryPrice;
  dynamic deliveryRatingSuccess;
  String displayName;
  dynamic effectiveDate;
  String expectedDate;
  dynamic fiscalPositionId;
  dynamic hasDelivery;
  int id;
  dynamic incoterm;
  int invoiceCount;
  List<dynamic> invoiceIds;
  dynamic invoiceShippingOnDelivery;
  String invoiceStatus;
  dynamic isAbandonedCart;
  dynamic isExpired;
  int messageAttachmentCount;
  List<dynamic> messageChannelIds;
  List<dynamic> messageFollowerIds;
  dynamic messageHasError;
  int messageHasErrorCounter;
  List<dynamic> messageIds;
  dynamic messageIsFollower;
  dynamic messageMainAttachmentId;
  dynamic messageNeedaction;
  int messageNeedactionCounter;
  List<dynamic> messagePartnerIds;
  dynamic messageUnread;
  int messageUnreadCounter;
  String name;
  String note;
  dynamic onlyServices;
  List<dynamic> orderLine;
  dynamic origin;
  List<dynamic> partnerId;
  List<dynamic> partnerInvoiceId;
  List<dynamic> partnerShippingId;
  dynamic paymentTermId;
  List<dynamic> pickingIds;
  String pickingPolicy;
  List<dynamic> pricelistId;
  dynamic procurementGroupId;
  int recurringInterval;
  dynamic recurringRuleType;
  dynamic reference;
  int remainingValidityDays;
  dynamic requirePayment;
  dynamic requireSignature;
  List<dynamic> saleOrderOptionIds;
  dynamic saleOrderTemplateId;
  dynamic signature;
  dynamic signedBy;
  String state;
  List<dynamic> teamId;
  List<dynamic> transactionIds;
  List<dynamic> transporterId;
  String typeName;
  List<dynamic> userId;
  dynamic validityDate;
  List<dynamic> warehouseId;
  dynamic warningStock;
  dynamic websiteId;
  List<dynamic> websiteMessageIds;
  List<dynamic> websiteOrderLine;
  String writeDate;
  List<dynamic> writeUid;
  dynamic xIsSameCustomerAddress;
  List<dynamic> xPickupAddress;
  dynamic xSchool;
  dynamic xStartDate;
  List<dynamic> xVehicles;

  SaleOrder(
      {this.sLastUpdate,
      this.accessToken,
      this.accessUrl,
      this.accessWarning,
      this.activityDateDeadline,
      this.activityIds,
      this.activityState,
      this.activitySummary,
      this.activityTypeId,
      this.activityUserId,
      this.amountByGroup,
      this.amountDelivery,
      this.amountTax,
      this.amountTotal,
      this.amountUndiscounted,
      this.amountUntaxed,
      this.analyticAccountId,
      this.authorizedTransactionIds,
      this.availableCarrierIds,
      this.carrierId,
      this.cartQuantity,
      this.cartRecoveryEmailSent,
      this.clientOrderRef,
      this.commitmentDate,
      this.companyId,
      this.confirmationDate,
      this.createDate,
      this.createUid,
      this.currencyId,
      this.currencyRate,
      this.dateOrder,
      this.deliveryCount,
      this.deliveryMessage,
      this.deliveryPrice,
      this.deliveryRatingSuccess,
      this.displayName,
      this.effectiveDate,
      this.expectedDate,
      this.fiscalPositionId,
      this.hasDelivery,
      this.id,
      this.incoterm,
      this.invoiceCount,
      this.invoiceIds,
      this.invoiceShippingOnDelivery,
      this.invoiceStatus,
      this.isAbandonedCart,
      this.isExpired,
      this.messageAttachmentCount,
      this.messageChannelIds,
      this.messageFollowerIds,
      this.messageHasError,
      this.messageHasErrorCounter,
      this.messageIds,
      this.messageIsFollower,
      this.messageMainAttachmentId,
      this.messageNeedaction,
      this.messageNeedactionCounter,
      this.messagePartnerIds,
      this.messageUnread,
      this.messageUnreadCounter,
      this.name,
      this.note,
      this.onlyServices,
      this.orderLine,
      this.origin,
      this.partnerId,
      this.partnerInvoiceId,
      this.partnerShippingId,
      this.paymentTermId,
      this.pickingIds,
      this.pickingPolicy,
      this.pricelistId,
      this.procurementGroupId,
      this.recurringInterval,
      this.recurringRuleType,
      this.reference,
      this.remainingValidityDays,
      this.requirePayment,
      this.requireSignature,
      this.saleOrderOptionIds,
      this.saleOrderTemplateId,
      this.signature,
      this.signedBy,
      this.state,
      this.teamId,
      this.transactionIds,
      this.transporterId,
      this.typeName,
      this.userId,
      this.validityDate,
      this.warehouseId,
      this.warningStock,
      this.websiteId,
      this.websiteMessageIds,
      this.websiteOrderLine,
      this.writeDate,
      this.writeUid,
      this.xIsSameCustomerAddress,
      this.xPickupAddress,
      this.xSchool,
      this.xStartDate,
      this.xVehicles});

  SaleOrder.fromJson(Map<String, dynamic> json) {
    sLastUpdate = json['__last_update'];
    accessToken = json['access_token'];
    accessUrl = json['access_url'];
    accessWarning = json['access_warning'];
    activityDateDeadline = json['activity_date_deadline'];
    if (json["activity_ids"] != null) {
      activityIds = List<dynamic>.from(
          json["activity_ids"] != null ? json["activity_ids"] : []);
    }
    activityState = json['activity_state'];
    activitySummary = json['activity_summary'];
    activityTypeId = json['activity_type_id'];
    activityUserId = json['activity_user_id'];
    if (json["amount_by_group"] != null) {
      amountByGroup = List<dynamic>.from(
          json["amount_by_group"] != null ? json["amount_by_group"] : []);
    }
    amountDelivery = json['amount_delivery'];
    amountTax = json['amount_tax'];
    amountTotal = json['amount_total'];
    amountUndiscounted = json['amount_undiscounted'];
    amountUntaxed = json['amount_untaxed'];
    analyticAccountId = json['analytic_account_id'];
    if (json["authorized_transaction_ids"] != null) {
      authorizedTransactionIds = List<dynamic>.from(
          json["authorized_transaction_ids"] != null
              ? json["authorized_transaction_ids"]
              : []);
    }
    if (json["available_carrier_ids"] != null) {
      availableCarrierIds = List<dynamic>.from(
          json["available_carrier_ids"] != null
              ? json["available_carrier_ids"]
              : []);
    }
    carrierId = json['carrier_id'];
    cartQuantity = json['cart_quantity'];
    cartRecoveryEmailSent = json['cart_recovery_email_sent'];
    clientOrderRef = json['client_order_ref'];
    commitmentDate = json['commitment_date'];
    if (json["company_id"] != null) {
      companyId = List<dynamic>.from(
          json["company_id"] != null ? json["company_id"] : []);
    }
    confirmationDate = json['confirmation_date'];
    createDate = json['create_date'];
    if (json["create_uid"] != null) {
      createUid = List<dynamic>.from(
          json["create_uid"] != null ? json["create_uid"] : []);
    }
    if (json["currency_id"] != null) {
      currencyId = List<dynamic>.from(
          json["currency_id"] != null ? json["currency_id"] : []);
    }
    currencyRate = json['currency_rate'];
    dateOrder = json['date_order'];
    deliveryCount = json['delivery_count'];
    deliveryMessage = json['delivery_message'];
    deliveryPrice = json['delivery_price'];
    deliveryRatingSuccess = json['delivery_rating_success'];
    displayName = json['display_name'];
    effectiveDate = json['effective_date'];
    expectedDate = json['expected_date'];
    fiscalPositionId = json['fiscal_position_id'];
    hasDelivery = json['has_delivery'];
    id = json['id'];
    incoterm = json['incoterm'];
    invoiceCount = json['invoice_count'];
    if (json["invoice_ids"] != null) {
      invoiceIds = List<dynamic>.from(
          json["invoice_ids"] != null ? json["invoice_ids"] : []);
    }
    invoiceShippingOnDelivery = json['invoice_shipping_on_delivery'];
    invoiceStatus = json['invoice_status'];
    isAbandonedCart = json['is_abandoned_cart'];
    isExpired = json['is_expired'];
    messageAttachmentCount = json['message_attachment_count'];
    if (json["message_channel_ids"] != null) {
      messageChannelIds = List<dynamic>.from(json["message_channel_ids"] != null
          ? json["message_channel_ids"]
          : []);
    }
    if (json["message_follower_ids"] != null) {
      messageFollowerIds = List<dynamic>.from(
          json["message_follower_ids"] != null
              ? json["message_follower_ids"]
              : []);
    }
    messageHasError = json['message_has_error'];
    messageHasErrorCounter = json['message_has_error_counter'];
    if (json["message_ids"] != null) {
      messageIds = List<dynamic>.from(
          json["message_ids"] != null ? json["message_ids"] : []);
    }
    messageIsFollower = json['message_is_follower'];
    messageMainAttachmentId = json['message_main_attachment_id'];
    messageNeedaction = json['message_needaction'];
    messageNeedactionCounter = json['message_needaction_counter'];
    if (json["message_partner_ids"] != null) {
      messagePartnerIds = List<dynamic>.from(json["message_partner_ids"] != null
          ? json["message_partner_ids"]
          : []);
    }
    messageUnread = json['message_unread'];
    messageUnreadCounter = json['message_unread_counter'];
    name = json['name'];
    note = json['note'];
    onlyServices = json['only_services'];
    if (json["order_line"] != null) {
      orderLine = List<dynamic>.from(
          json["order_line"] != null ? json["order_line"] : []);
    }
    origin = json['origin'];
    if (json["partner_id"] != null) {
      partnerId = List<dynamic>.from(
          json["partner_id"] != null ? json["partner_id"] : []);
    }
    if (json["partner_invoice_id"] != null) {
      partnerInvoiceId = List<dynamic>.from(
          json["partner_invoice_id"] != null ? json["partner_invoice_id"] : []);
    }
    if (json["partner_shipping_id"] != null) {
      partnerShippingId = List<dynamic>.from(json["partner_shipping_id"] != null
          ? json["partner_shipping_id"]
          : []);
    }
    paymentTermId = json['payment_term_id'];
    if (json["picking_ids"] != null) {
      pickingIds = List<dynamic>.from(
          json["picking_ids"] != null ? json["picking_ids"] : []);
    }
    pickingPolicy = json['picking_policy'];
    if (json["pricelist_id"] != null) {
      pricelistId = List<dynamic>.from(
          json["pricelist_id"] != null ? json["pricelist_id"] : []);
    }
    procurementGroupId = json['procurement_group_id'];
    recurringInterval = json['recurring_interval'];
    recurringRuleType = json['recurring_rule_type'];
    reference = json['reference'];
    remainingValidityDays = json['remaining_validity_days'];
    requirePayment = json['require_payment'];
    requireSignature = json['require_signature'];
    if (json["sale_order_option_ids"] != null) {
      saleOrderOptionIds = List<dynamic>.from(
          json["sale_order_option_ids"] != null
              ? json["sale_order_option_ids"]
              : []);
    }
    saleOrderTemplateId = json['sale_order_template_id'];
    signature = json['signature'];
    signedBy = json['signed_by'];
    state = json['state'];
    if (json["team_id"] != null) {
      teamId =
          List<dynamic>.from(json["team_id"] != null ? json["team_id"] : []);
    }
    if (json["transaction_ids"] != null) {
      transactionIds = List<dynamic>.from(
          json["transaction_ids"] != null ? json["transaction_ids"] : []);
    }
    if (json["transporter_id"] != null) {
      transporterId = List<dynamic>.from(
          json["transporter_id"] != null ? json["transporter_id"] : []);
    }
    typeName = json['type_name'];
    if (json["user_id"] != null) {
      userId =
          List<dynamic>.from(json["user_id"] != null ? json["user_id"] : []);
    }
    validityDate = json['validity_date'];
    if (json["warehouse_id"] != null) {
      warehouseId = List<dynamic>.from(
          json["warehouse_id"] != null ? json["warehouse_id"] : []);
    }
    warningStock = json['warning_stock'];
    websiteId = json['website_id'];
    if (json["website_message_ids"] != null) {
      websiteMessageIds = List<dynamic>.from(json["website_message_ids"] != null
          ? json["website_message_ids"]
          : []);
    }
    if (json["website_order_line"] != null) {
      websiteOrderLine = List<dynamic>.from(
          json["website_order_line"] != null ? json["website_order_line"] : []);
    }
    writeDate = json['write_date'];
    if (json["write_uid"] != null) {
      writeUid = List<dynamic>.from(
          json["write_uid"] != null ? json["write_uid"] : []);
    }
    xIsSameCustomerAddress = json['x_is_same_customer_address'];
    if (json["x_pickup_address"] != null) {
      xPickupAddress = List<dynamic>.from(
          json["x_pickup_address"] != null ? json["x_pickup_address"] : []);
    }
    xSchool = json['x_school'];
    xStartDate = json['x_start_date'];
    if (json["x_vehicles"] != null) {
      xVehicles = List<dynamic>.from(
          json["x_vehicles"] != null ? json["x_vehicles"] : []);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__last_update'] = this.sLastUpdate;
    data['access_token'] = this.accessToken;
    data['access_url'] = this.accessUrl;
    data['access_warning'] = this.accessWarning;
    data['activity_date_deadline'] = this.activityDateDeadline;
    data['activity_ids'] = this.activityIds;
    data['activity_state'] = this.activityState;
    data['activity_summary'] = this.activitySummary;
    data['activity_type_id'] = this.activityTypeId;
    data['activity_user_id'] = this.activityUserId;
    data['amount_by_group'] = this.amountByGroup;
    data['amount_delivery'] = this.amountDelivery;
    data['amount_tax'] = this.amountTax;
    data['amount_total'] = this.amountTotal;
    data['amount_undiscounted'] = this.amountUndiscounted;
    data['amount_untaxed'] = this.amountUntaxed;
    data['analytic_account_id'] = this.analyticAccountId;
    data['authorized_transaction_ids'] = this.authorizedTransactionIds;
    data['available_carrier_ids'] = this.availableCarrierIds;
    data['carrier_id'] = this.carrierId;
    data['cart_quantity'] = this.cartQuantity;
    data['cart_recovery_email_sent'] = this.cartRecoveryEmailSent;
    data['client_order_ref'] = this.clientOrderRef;
    data['commitment_date'] = this.commitmentDate;
    data['company_id'] = this.companyId;
    data['confirmation_date'] = this.confirmationDate;
    data['create_date'] = this.createDate;
    data['create_uid'] = this.createUid;
    data['currency_id'] = this.currencyId;
    data['currency_rate'] = this.currencyRate;
    data['date_order'] = this.dateOrder;
    data['delivery_count'] = this.deliveryCount;
    data['delivery_message'] = this.deliveryMessage;
    data['delivery_price'] = this.deliveryPrice;
    data['delivery_rating_success'] = this.deliveryRatingSuccess;
    data['display_name'] = this.displayName;
    data['effective_date'] = this.effectiveDate;
    data['expected_date'] = this.expectedDate;
    data['fiscal_position_id'] = this.fiscalPositionId;
    data['has_delivery'] = this.hasDelivery;
    data['id'] = this.id;
    data['incoterm'] = this.incoterm;
    data['invoice_count'] = this.invoiceCount;
    data['invoice_ids'] = this.invoiceIds;
    data['invoice_shipping_on_delivery'] = this.invoiceShippingOnDelivery;
    data['invoice_status'] = this.invoiceStatus;
    data['is_abandoned_cart'] = this.isAbandonedCart;
    data['is_expired'] = this.isExpired;
    data['message_attachment_count'] = this.messageAttachmentCount;
    data['message_channel_ids'] = this.messageChannelIds;
    data['message_follower_ids'] = this.messageFollowerIds;
    data['message_has_error'] = this.messageHasError;
    data['message_has_error_counter'] = this.messageHasErrorCounter;
    data['message_ids'] = this.messageIds;
    data['message_is_follower'] = this.messageIsFollower;
    data['message_main_attachment_id'] = this.messageMainAttachmentId;
    data['message_needaction'] = this.messageNeedaction;
    data['message_needaction_counter'] = this.messageNeedactionCounter;
    data['message_partner_ids'] = this.messagePartnerIds;
    data['message_unread'] = this.messageUnread;
    data['message_unread_counter'] = this.messageUnreadCounter;
    data['name'] = this.name;
    data['note'] = this.note;
    data['only_services'] = this.onlyServices;
    data['order_line'] = this.orderLine;
    data['origin'] = this.origin;
    data['partner_id'] = this.partnerId;
    data['partner_invoice_id'] = this.partnerInvoiceId;
    data['partner_shipping_id'] = this.partnerShippingId;
    data['payment_term_id'] = this.paymentTermId;
    data['picking_ids'] = this.pickingIds;
    data['picking_policy'] = this.pickingPolicy;
    data['pricelist_id'] = this.pricelistId;
    data['procurement_group_id'] = this.procurementGroupId;
    data['recurring_interval'] = this.recurringInterval;
    data['recurring_rule_type'] = this.recurringRuleType;
    data['reference'] = this.reference;
    data['remaining_validity_days'] = this.remainingValidityDays;
    data['require_payment'] = this.requirePayment;
    data['require_signature'] = this.requireSignature;
    data['sale_order_option_ids'] = this.saleOrderOptionIds;
    data['sale_order_template_id'] = this.saleOrderTemplateId;
    data['signature'] = this.signature;
    data['signed_by'] = this.signedBy;
    data['state'] = this.state;
    data['team_id'] = this.teamId;
    data['transaction_ids'] = this.transactionIds;
    data['transporter_id'] = this.transporterId;
    data['type_name'] = this.typeName;
    data['user_id'] = this.userId;
    data['validity_date'] = this.validityDate;
    data['warehouse_id'] = this.warehouseId;
    data['warning_stock'] = this.warningStock;
    data['website_id'] = this.websiteId;
    data['website_message_ids'] = this.websiteMessageIds;
    data['website_order_line'] = this.websiteOrderLine;
    data['write_date'] = this.writeDate;
    data['write_uid'] = this.writeUid;
    data['x_is_same_customer_address'] = this.xIsSameCustomerAddress;
    data['x_pickup_address'] = this.xPickupAddress;
    data['x_school'] = this.xSchool;
    data['x_start_date'] = this.xStartDate;
    data['x_vehicles'] = this.xVehicles;
    return data;
  }
}
