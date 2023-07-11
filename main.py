import streamlit as st
import matplotlib.pyplot as plt
import pandas as pd
from database import query

ca_years = query.getCAPerYear() 

fig, ax = plt.subplots()
ax.bar(ca_years[0], ca_years[1])

ax.set_title('Chiffre d\'affaire par années')
ax.ticklabel_format(style='plain', axis="y")
st.pyplot(fig)
