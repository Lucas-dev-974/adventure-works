import streamlit as st
import plotly.express as px
from database import query

st.text('ok')

years, cas = query.getCAPerYear() 

fig = px.bar(y=cas, x=years)

st.plotly_chart(fig)
