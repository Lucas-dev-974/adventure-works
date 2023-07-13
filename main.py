import plotly.graph_objects as go
import plotly.express as px
from database import query
import streamlit as st
import pandas as pd



def showDepartmentsAndCost():
    st.title('Département & coût')
    department, numberEmployee, cost = query.getEmployeePerDepartmentAndTheyCost()
    data = {"Departement": department, "Nombre employer": numberEmployee, "Coût": cost}
    st.table(pd.DataFrame(data=data))

def showSalesPerCountry(tab):
    countries, sales = query.getSalesPerCountry()
    SalesPerCountry = [go.Choropleth(
        locations = countries,
        z = sales,
        locationmode = 'country names',
        colorscale = 'Blues',
        colorbar_title = 'Sales'
    )]

    layout = go.Layout(
        title = 'Sales by Country',
        geo = dict(
            showframe = False,
            projection = {'type':'natural earth'}
        )
    )

    SalesPerCountriesFig = go.Figure(data=SalesPerCountry, layout=layout)
    tab.plotly_chart(SalesPerCountriesFig)

def showCAPerYear(tab):
    years, cas = query.getCAPerYear() 
    TurnOverFig = px.bar(y=cas, x=years)
    tab.plotly_chart(TurnOverFig)

def showPieCasCountries(tab):
    countries, cas = query.getCAsCountries()
    countriesCASDataframe = pd.DataFrame({
        "countries": countries,
        "chiffre affaire": cas
    })
    fig = px.pie(countriesCASDataframe, values="chiffre affaire", names="countries")
    tab.plotly_chart(fig)

# resellersKey, resellersCas = query.getResselersCA()

# resellersCas = pd.DataFrame({
#     "Revendeur": resellersKey,
#     "Chiffre d'affaire": resellersCas
# })

# fig = px.pie(resellersCas, values="Chiffre d'affaire", names="Revendeur")
# st.plotly_chart(fig)

def showTabs():
    st.title('Graphiques')

    tab1, tab2, tab3 = st.tabs(["Ventes par régions", 
                                "📈 Chiffre d'affaire par années", 
                                "Chiffre d'affaire par pei"])
                                
    showSalesPerCountry(tab1)
    showCAPerYear(tab2)
    showPieCasCountries(tab3)

showDepartmentsAndCost()
showTabs()
