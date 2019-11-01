view: pf_campaign {
  derived_table: {
    sql: SELECT
      gec.timestamp::DATE AS timestamp_date,
      Count(distinct case when gec.total_paid_claims > 0 then gec.goodevent_coupon_id end) as coupons_with_claims,
      count(distinct case when gec.total_paid_claims > 0 then gec.group_network_member else null end) as coupons_with_claims2,
      COUNT(DISTINCT CASE WHEN r.is_paid_claim THEN gec.group_network_member ELSE NULL END) AS total_coupons_redeemed,
      COUNT(DISTINCT CASE WHEN r.is_paid_claim THEN claim_id ELSE NULL END) AS total_paid_claims
      FROM goodrx.goodevent_coupons AS gec
      LEFT JOIN goodrx.claims_fact AS r USING (group_network_member)
      WHERE gec.coupon_campaign_keyword = 'pf_stp_now'
      AND gec.coupon_application = 'API'
      AND gec.timestamp::DATE < current_date -1
      GROUP BY 1
      ORDER BY 1 ASC;
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: timestamp_date {
    type: date
    sql: ${TABLE}.timestamp_date ;;
  }

  dimension: coupons_with_claims {
    type: number
    sql: ${TABLE}.coupons_with_claims ;;
  }

  dimension: coupons_with_claims2 {
    type: number
    sql: ${TABLE}.coupons_with_claims2 ;;
  }

  dimension: total_coupons_redeemed {
    type: number
    sql: ${TABLE}.total_coupons_redeemed ;;
  }

  dimension: total_paid_claims {
    type: number
    sql: ${TABLE}.total_paid_claims ;;
  }

  set: detail {
    fields: [timestamp_date, coupons_with_claims, coupons_with_claims2, total_coupons_redeemed, total_paid_claims]
  }
}
