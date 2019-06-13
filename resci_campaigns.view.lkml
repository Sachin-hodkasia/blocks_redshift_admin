view: resci_campaigns {
  derived_table: {
    sql: SELECT
      s.medium,
      s.traffic_source,
      s.campaign,
      s.ad_content,
      MIN(s.session_date):: DATE AS min_session_date,
      MAX(s.session_date):: DATE AS max_session_date,
      COUNT(DISTINCT s.session_id) AS sessions,
      COUNT(DISTINCT s.visitor_id) AS visitors,
      COUNT (DISTINCT c.group_network_member) AS coupons,
      COUNT (DISTINCT cf.claim_id) AS claims,
      (COUNT(DISTINCT(CASE WHEN cf.is_paid_claim = 1 THEN s.session_id ELSE NULL END))*1.00)/COUNT(DISTINCT s.session_id) percent_sessions_with_claims,
      (COUNT(DISTINCT(CASE WHEN cf.is_paid_claim = 1 THEN s.visitor_id ELSE NULL END))*1.00)/COUNT(DISTINCT s.visitor_id)  percent_visitors_with_claims
      FROM goodrx.ga_sessions s
      LEFT JOIN goodrx.ga_coupons c
        ON s.session_id = c.session_id
      LEFT JOIN goodrx.claims_fact cf
        ON c.group_network_member = cf.group_network_member
      WHERE s.traffic_source = 'resci' AND s.medium = 'email'
      GROUP BY 1,2,3,4
      ORDER BY 1,2,3,4
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: medium {
    type: string
    sql: ${TABLE}.medium ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }

  dimension: ad_content {
    type: string
    sql: ${TABLE}.ad_content ;;
  }

  dimension: min_session_date {
    type: date
    sql: ${TABLE}.min_session_date ;;
  }

  dimension: max_session_date {
    type: date
    sql: ${TABLE}.max_session_date ;;
  }

  dimension: sessions {
    type: number
    sql: ${TABLE}.sessions ;;
  }

  dimension: visitors {
    type: number
    sql: ${TABLE}.visitors ;;
  }

  dimension: coupons {
    type: number
    sql: ${TABLE}.coupons ;;
  }

  dimension: claims {
    type: number
    sql: ${TABLE}.claims ;;
  }

  dimension: percent_sessions_with_claims {
    type: number
    sql: ${TABLE}.percent_sessions_with_claims
    value_format: "0.00%";;
  }

  dimension: percent_visitors_with_claims {
    type: number
    sql: ${TABLE}.percent_visitors_with_claims
    value_format: "0.00%";;
  }

  set: detail {
    fields: [
      medium,
      traffic_source,
      campaign,
      ad_content,
      min_session_date,
      max_session_date,
      sessions,
      visitors,
      coupons,
      claims,
      percent_sessions_with_claims,
      percent_visitors_with_claims
    ]
  }
}
