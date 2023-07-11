SELECT
    TOP(1) *,
    CAST(
        humanresources.employee.OrganizationNode AS NVARCHAR(4000)
    ) as OrganizationNode
FROM
    humanresources.employee
ORDER BY
    jobtitle;

-- --------------------
SELECT
    *
FROM
    person.person
ORDER BY
    LastName;

-- --------------------
SELECT
    firstname,
    lastname,
    businessentityid as Employee_id
FROM
    person.person AS e
ORDER BY
    lastname;

-- --------------------
SELECT
    productid,
    productnumber,
    name as producName
FROM
    production.product
WHERE
    sellstartdate IS NOT NULL
    AND production.product.productline = 'T'
ORDER BY
    name;

-- --------------------
SELECT
    salesorderid,
    customerid,
    orderdate,
    subtotal,
    (taxamt * 100) / subtotal AS Tax_percent
FROM
    sales.salesorderheader
ORDER BY
    subtotal desc;

-- ---------------------
SELECT
    DISTINCT jobtitle
FROM
    humanresources.employee
ORDER BY
    jobtitle;

-- ---------------------------
SELECT
    DISTINCT jobtitle
FROM
    humanresources.employee
ORDER BY
    jobtitle;