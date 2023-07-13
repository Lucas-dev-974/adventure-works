import pyodbc 
import pandas as pd
import os
from dotenv import load_dotenv

load_dotenv()

# server = 'localhost'
# database = 'AdventureWorksDW' 
# username = 'sa' 
# password = 'system#root' 

server = '20.4.206.214'
database = 'AdventureWorksDW2019' 
# username = 'sa' 
# username = os.environ["DATABASE_USERNAME"]
username = str(os.getenv("DATABASE_USERNAME"))
# password = 'yourStrong_Password' 
# password = os.environ["DATABASE_PASSWORD"]
password = str(os.getenv("DATABASE_USERNAME"))

def HandleHierarchyId(v):
    return str(v)

cnxn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER='
                      +server
                      +';DATABASE='
                      +database
                      +';ENCRYPT=yes;UID='
                      +username
                      +';PWD='
                      + password 
                      + ';TrustServerCertificate=Yes')

cnxn.add_output_converter(-151, HandleHierarchyId)

def executeSelect(sql):
    cursor = cnxn.cursor()
    cursor.execute(sql)  
    result = cursor.fetchall()
    cursor.close()
    return result

class query:
    def getCAPerYear():
        result = executeSelect(''' 
            SELECT
                SUM(UnitPrice) AS Sales,
                YEAR(OrderDate) as YearOfSale
            FROM
                FactInternetSales
            GROUP BY
                YEAR(OrderDate)
            ORDER by
                YearOfSale
        ''')
        
        normalized = [[item[1], float(item[0])] for item in result]
       
        years = []
        cas = []

        for item in normalized:
            years.append(str(item[0]))
            cas.append(int(item[1]))


        return years, cas
    
    def getSalesPerCountry():
        result = executeSelect('''
            SELECT
                dimSalesTerr.SalesTerritoryCountry,
                (SELECT COUNT(*) FROM dbo.FactInternetSales as subFactWebSales
                INNER JOIN dbo.DimSalesTerritory as subDimSalesTerr ON subFactWebSales.SalesTerritoryKey = subDimSalesTerr.SalesTerritoryKey
                WHERE subDimSalesTerr.SalesTerritoryCountry = dimSalesTerr.SalesTerritoryCountry) AS NbSalesPerCountry
            FROM
                dbo.FactInternetSales as factWebSales
                INNER JOIN dbo.DimSalesTerritory as dimSalesTerr ON factWebSales.SalesTerritoryKey = dimSalesTerr.SalesTerritoryKey
            GROUP BY
                dimSalesTerr.SalesTerritoryCountry;
        ''')
        countries = []
        cas = []
        normalized = [[item[0], float(item[1])] for item in result]

        for countrie_, ca in normalized:
            countries.append(countrie_)
            cas.append(ca)
            
        return countries, cas
    
    def getEmployeePerDepartmentAndTheyCost():
        result = executeSelect('''
            SELECT
                departGroup.DepartmentGroupName,
                COUNT(departGroup.DepartmentGroupName) as nbtotal, 
                               SUM(FactFinance.Amount) as amount
            FROM
                FactFinance AS factfinance
                INNER JOIN Dimdepartmentgroup AS departGroup 
                               ON factfinance.DepartmentGroupKey = departGroup.DepartmentGroupKey
            GROUP BY
                departGroup.DepartmentGroupName
            ORDER BY
                nbtotal DESC
        ''')
        
        normalized = [[item[0], int(item[1]), float(item[2])] for item in result]
       
        department = []
        numberEmployee = []
        cost = []

        for item in normalized:
            department.append(item[0])
            numberEmployee.append(item[1])
            cost.append(item[2])

        return department, numberEmployee, cost
    
    def getAllResselersCA():
        result = executeSelect('''
            SELECT
                SUM(SalesAmount) AS TotalAmount
            FROM
                FactResellerSales
        ''')
        normalized = [[item[0], float(item[1])] for item in result]

        resellers = []
        amountCA = []

        for item in normalized:
            resellers.append(item[0])
            amountCA.append(item[1])

        return resellers, amountCA

    def getCAsCountries():
        result = executeSelect(''' 
            SELECT
                dimTerr.SalesTerritoryCountry,
                SUM(factWebSales.UnitPrice) as CAcountry
            FROM
                FactInternetSales as factWebSales
                INNER JOIN DimSalesTerritory as dimTerr ON factWebSales.SalesTerritoryKey = dimTerr.SalesTerritoryKey
            GROUP BY
                dimTerr.SalesTerritoryCountry
        ''')

        normalized = [[item[0], float(item[1])] for item in result]

        countries = []
        cas = []

        for item in normalized:
            countries.append(item[0])
            cas.append(item[1])

        return countries, cas
    
print(query.getCAsCountries())