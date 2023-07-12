import streamlit as st
from database import query
import plotly.express as px

years, cas = query.getCAPerYear() 

fig = px.bar(y=cas, x=years)

st.plotly_chart(fig)
