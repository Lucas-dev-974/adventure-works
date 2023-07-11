import streamlit as st
from database import query

st.title('Adventure work')

st.text('Nombre d\'employer aux Ressource humaine enregistrer: ' 
        + str(query.humanRessourceEmployeeCount()))

st.text('Nombre d\'employer de personnes enregistrer: ' 
        + str(query.PersonCount()))

print( [t[0] for t in query.jobList()] )