import plotly.graph_objects as go
import plotly.express as px
from database import query
import streamlit as st
import pandas as pd

st.title('Département & coût')
department, numberEmployee, cost = query.getEmployeePerDepartmentAndTheyCost()
data = {"Departement": department, "Nombre employer": numberEmployee, "Coût": cost}
st.table(pd.DataFrame(data=data))

st.title('Graphiques')

tab1, tab2 = st.tabs(["Ventes par régions", "📈 Chiffre d'affaire par années"])

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
tab1.plotly_chart(SalesPerCountriesFig)


years, cas = query.getCAPerYear() 

TurnOverFig = px.bar(y=cas, x=years)
tab2.plotly_chart(TurnOverFig)

