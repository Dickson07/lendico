SELECT a.report_date 'Report date', a.investor_id, a.investment_id,
b.planned_total 'Planned Total',
(a.received_principal + a.received_interest) - a.paid_fee 'Recieved Total',
b.planned_interest 'Planned Interest', a.received_interest 'Recieved Interest',
b.planned_principal 'Planned Principal', a.received_principal 'Recieved Principal',  
b.planned_fee 'Planned Fee', a.paid_fee 'Paid Fee', 
b.Name, b.street Street, b.streetNumber 'Street Number', b.zip Zip,
b.iban IBAN, b.bic BIC
FROM (SELECT
 DATE(c.`cleared_at`) report_date,
 c.`investor_id`,
 c.`investment_id`,
 CAST(IFNULL(SUM(CASE WHEN c.`item_type` = 'principal' THEN c.`amount` END),0) AS DECIMAL(12,2)) AS received_principal,
 CAST(IFNULL(SUM(CASE WHEN c.`item_type` = 'interest' THEN c.`amount` END),0) AS DECIMAL(12,2)) AS received_interest,
 CAST(IFNULL(SUM(CASE WHEN c.`item_type` = 'investor_fee' THEN c.`amount` END),0) AS DECIMAL(12,2)) AS paid_fee
FROM `cashflow` c
GROUP BY report_date, c.`investor_id`, c.`investment_id`) a LEFT JOIN(SELECT
 p.plan_id,
 p.investor_id,
 p.investment_id,
 CAST(SUM(pe.`total`) AS DECIMAL(12,2)) planned_total,
 CAST(SUM(pe.`principal`) AS DECIMAL(12,2)) planned_principal,
 CAST(SUM(pe.`interest`) AS DECIMAL(12,2)) planned_interest,
 CAST(SUM(pe.fee) AS DECIMAL(12,2)) planned_fee,
 CONCAT(u.`firstName`,' ',`lastName`) `Name`, u.`street`, u.`streetNumber`,
 u.`zip`,
 b.`iban`,
 b.`bic`
FROM `plan` p 
INNER JOIN `plan_entries` pe USING (plan_id)
INNER JOIN `user_data` u ON (p.`investor_id` = u.`investorid`)
INNER JOIN `bank_data` b ON (b.`investorid` = u.`investorid`)
GROUP BY p.investment_id) b ON (a.investor_id = b.investor_id AND a.investment_id = b.investment_id);
