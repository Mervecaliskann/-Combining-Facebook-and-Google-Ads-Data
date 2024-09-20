WITH facebook_data AS (
    SELECT
        fad.ad_date,
        fc.campaign_name,
        fa.adset_name,
        fad.spend,
        fad.impressions,
        fad.reach,
        fad.clicks,
        fad.leads,
        fad.value
    FROM 
    	facebook_ads_basic_daily fad
    INNER JOIN 
    	facebook_adset fa 
    ON 
    	fad.adset_id = fa.adset_id
    INNER JOIN 
    	facebook_campaign fc 
    ON 
    	fad.campaign_id = fc.campaign_id
),
google_data AS (
    SELECT
        gab.ad_date,
        gab.campaign_name,
        gab.adset_name,
        gab.spend,
        gab.impressions,
        gab.reach,
        gab.clicks,
        gab.leads,
        gab.value
    FROM 
    	google_ads_basic_daily gab
),
combined_data AS (
    SELECT 
    	* 
    FROM 
    	facebook_data
    UNION ALL
    SELECT 
    	* 
    FROM 
    	google_data
)

SELECT
    ad_date,
    'Facebook Ads' AS media_source,
    campaign_name,
    adset_name,
    SUM(spend) AS toplam_maliyet,
    SUM(impressions) AS toplam_goruntuleme,
    SUM(clicks) AS toplam_tiklama,
    SUM(clicks)::numeric /SUM(impressions)::numeric AS conversion_rate
FROM facebook_data
WHERE clicks > 0 AND impressions > 0 AND clicks IS NOT NULL AND impressions IS NOT NULL
GROUP BY ad_date, media_source, campaign_name, adset_name
UNION ALL
SELECT
    ad_date,
    'Google Ads' AS media_source,
    campaign_name,
    adset_name,
    SUM(spend) AS toplam_maliyet,
    SUM(impressions) AS toplam_goruntuleme,
    SUM(clicks) AS toplam_tiklama,
    SUM(clicks)::numeric /SUM(impressions)::numeric AS conversion_rate
FROM google_data
WHERE clicks > 0 AND impressions > 0 AND clicks IS NOT NULL AND impressions IS NOT NULL
GROUP BY ad_date, media_source, campaign_name, adset_name;