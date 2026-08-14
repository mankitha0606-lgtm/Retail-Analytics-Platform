
from pathlib import Path
import streamlit as st
import pandas as pd
import joblib


# ============================================================
# LOAD MODEL
# ============================================================

BASE_DIR = Path(__file__).resolve().parent

model = joblib.load(
    BASE_DIR / "gradient_boosting_loss_model.pkl"
)

config = joblib.load(
    BASE_DIR / "feature_config.pkl"
)

THRESHOLD = config["threshold"]


# ============================================================
# PAGE CONFIGURATION
# ============================================================

st.set_page_config(
    page_title="Retail Loss Risk Predictor",
    page_icon="📊",
    layout="wide"
)


# ============================================================
# CUSTOM CSS
# ============================================================

st.markdown("""
<style>

.main-title {
    font-size: 42px;
    font-weight: 700;
    margin-bottom: 5px;
}

.subtitle {
    font-size: 17px;
    color: #666666;
    margin-bottom: 30px;
}

.section-title {
    font-size: 27px;
    font-weight: 600;
    margin-top: 20px;
}

.info-box {
    padding: 20px;
    border-radius: 12px;
    background-color: #f5f7fa;
    margin-top: 15px;
}

.metric-title {
    font-size: 15px;
    color: #666666;
}

.metric-value {
    font-size: 30px;
    font-weight: 700;
}


<style>
.stApp { background: radial-gradient(circle at 10% 0%, rgba(99,102,241,.10), transparent 28%), radial-gradient(circle at 90% 10%, rgba(14,165,233,.10), transparent 25%), #f8fafc; }
.block-container { max-width: 1400px; padding-top: 2rem; padding-bottom: 3rem; }
.hero-badge { display:inline-block; padding:6px 12px; border-radius:999px; background:#eef2ff; color:#3730a3; font-size:12px; font-weight:800; letter-spacing:.5px; margin-bottom:10px; }
.main-title { font-size:42px; font-weight:800; color:#172554; margin-bottom:6px; }
.subtitle { font-size:17px; color:#64748b; margin-bottom:28px; }
.section-title { font-size:28px; font-weight:800; color:#172554; margin-top:25px; }
.info-box { padding:22px; border-radius:18px; background:linear-gradient(135deg,#eff6ff,#eef2ff); border:1px solid #c7d2fe; margin-top:18px; }
.stButton > button { border-radius:12px; min-height:50px; font-weight:800; color:white; border:0; background:linear-gradient(135deg,#4f46e5,#0284c7); box-shadow:0 8px 20px rgba(37,99,235,.20); }
.stButton > button:hover { transform:translateY(-1px); }
</style>

""", unsafe_allow_html=True)


# ============================================================
# HEADER
# ============================================================

st.markdown(
    '<div class="hero-badge">🤖 MACHINE LEARNING • RETAIL ANALYTICS</div><div class="main-title">Retail Transaction Loss Risk Predictor</div>',
    unsafe_allow_html=True
)

st.markdown(
    '<div class="subtitle">'
    'Predict whether a retail transaction is likely to be loss-making '
    'using a Gradient Boosting Machine Learning model.'
    '</div>',
    unsafe_allow_html=True
)


# ============================================================
# TRANSACTION INPUTS
# ============================================================

st.markdown(
    '<div class="section-title">Transaction Details</div>',
    unsafe_allow_html=True
)

col1, col2, col3 = st.columns(3)


# ------------------------------------------------------------
# COLUMN 1
# ------------------------------------------------------------

with col1:

    sales = st.number_input(
        "💰 Sales",
        min_value=0.0,
        value=100.0,
        step=10.0
    )

    quantity = st.number_input(
        "📦 Quantity",
        min_value=1,
        value=2,
        step=1
    )

    discount = st.number_input(
        "🏷️ Discount",
        min_value=0.0,
        max_value=1.0,
        value=0.0,
        step=0.05,
        help="Enter discount as a decimal. Example: 20% = 0.20"
    )

    shipping_cost = st.number_input(
        "🚚 Shipping Cost",
        min_value=0.0,
        value=10.0,
        step=1.0
    )


# ------------------------------------------------------------
# COLUMN 2
# ------------------------------------------------------------

with col2:

    shipping_days = st.number_input(
        "📦 Shipping Days",
        min_value=0,
        value=4,
        step=1
    )

    order_year = st.number_input(
        "📅 Order Year",
        min_value=2012,
        max_value=2030,
        value=2015,
        step=1
    )

    order_month = st.number_input(
        "🗓️ Order Month",
        min_value=1,
        max_value=12,
        value=6,
        step=1
    )

    order_day_of_week = st.number_input(
        "📆 Order Day of Week",
        min_value=0,
        max_value=6,
        value=2,
        step=1,
        help="0 = Monday, 6 = Sunday"
    )


# ------------------------------------------------------------
# COLUMN 3
# ------------------------------------------------------------

with col3:

    category = st.selectbox(
        "🗂️ Category",
        [
            "Technology",
            "Furniture",
            "Office Supplies"
        ]
    )

    subcategory = st.text_input(
        "📁 Sub-Category",
        value="Phones"
    )

    segment = st.selectbox(
        "👥 Segment",
        [
            "Consumer",
            "Corporate",
            "Home Office"
        ]
    )

    region = st.text_input(
        "🌍 Region",
        value="Western Europe"
    )


col4, col5 = st.columns(2)


with col4:

    market = st.text_input(
        "🌐 Market",
        value="EU"
    )


with col5:

    ship_mode = st.selectbox(
        "🚛 Ship Mode",
        [
            "Standard Class",
            "Second Class",
            "First Class",
            "Same Day"
        ]
    )

    order_priority = st.selectbox(
        "⚡ Order Priority",
        [
            "Low",
            "Medium",
            "High",
            "Critical"
        ]
    )


# ============================================================
# PREDICTION BUTTON
# ============================================================

st.markdown("")

predict_button = st.button(
    "🔍 Predict Loss Risk",
    use_container_width=True
)


# ============================================================
# PREDICTION
# ============================================================

if predict_button:

    input_data = pd.DataFrame([{

        "Sales": sales,
        "Quantity": quantity,
        "Discount": discount,
        "Shipping Cost": shipping_cost,
        "Shipping_Days": shipping_days,
        "Order_Year": order_year,
        "Order_Month": order_month,
        "Order_DayOfWeek": order_day_of_week,

        "Category": category,
        "Sub-Category": subcategory,
        "Segment": segment,
        "Region": region,
        "Market": market,
        "Ship Mode": ship_mode,
        "Order Priority": order_priority

    }])


    # --------------------------------------------------------
    # MODEL PREDICTION
    # --------------------------------------------------------

    probability = model.predict_proba(
        input_data
    )[0, 1]

    prediction = int(
        probability >= THRESHOLD
    )


    # ========================================================
    # RISK CLASSIFICATION
    # ========================================================

    if probability < 0.30:

        risk_level = "Low Risk"
        recommendation = (
            "The transaction has a low predicted probability "
            "of loss. The current configuration appears relatively safe."
        )

        st.success(
            "🟢 LOW LOSS RISK"
        )

    elif probability < 0.40:

        risk_level = "Moderate Risk"
        recommendation = (
            "The transaction has a moderate loss probability. "
            "Review the discount and shipping cost before proceeding."
        )

        st.warning(
            "🟡 MODERATE LOSS RISK"
        )

    elif probability < 0.60:

        risk_level = "High Risk"
        recommendation = (
            "The transaction has a high predicted loss probability. "
            "Consider reducing the discount or controlling shipping costs."
        )

        st.warning(
            "🟠 HIGH LOSS RISK"
        )

    else:

        risk_level = "Very High Risk"
        recommendation = (
            "The transaction has a very high predicted probability "
            "of loss. Review pricing, discount and shipping strategy "
            "before proceeding."
        )

        st.error(
            "🔴 VERY HIGH LOSS RISK"
        )


    # ========================================================
    # RESULTS
    # ========================================================

    st.markdown(
        '<div class="section-title">Prediction Results</div>',
        unsafe_allow_html=True
    )

    result_col1, result_col2, result_col3 = st.columns(3)


    with result_col1:

        st.metric(
            "Probability of Loss",
            f"{probability:.2%}"
        )


    with result_col2:

        st.metric(
            "Risk Level",
            risk_level
        )


    with result_col3:

        prediction_text = (
            "Loss-Making"
            if prediction == 1
            else
            "Profitable"
        )

        st.metric(
            "Prediction",
            prediction_text
        )


    # ========================================================
    # PROBABILITY BAR
    # ========================================================

    st.write("### Loss Probability")

    st.progress(
        min(float(probability), 1.0)
    )

    st.caption(
        f"Classification threshold: {THRESHOLD:.0%}"
    )


    # ========================================================
    # BUSINESS RECOMMENDATION
    # ========================================================

    st.markdown(
        f"""
        <div class="info-box">

        <h3>💡 Business Recommendation</h3>

        <p>{recommendation}</p>

        </div>
        """,
        unsafe_allow_html=True
    )


    # ========================================================
    # KEY FACTOR
    # ========================================================

    st.info(
        "📌 Model Insight: Discount was identified as the "
        "dominant predictive feature in the Gradient Boosting model."
    )


# ============================================================
# MODEL INFORMATION
# ============================================================

with st.expander("ℹ️ Model Information"):

    st.write(
        "**Model:** Gradient Boosting Classifier"
    )

    st.write(
        "**Classification Threshold:** 40%"
    )

    st.write(
        "**Accuracy:** 92.77%"
    )

    st.write(
        "**Precision:** 86.61%"
    )

    st.write(
        "**Recall:** 83.30%"
    )

    st.write(
        "**F1 Score:** 84.92%"
    )

    st.write(
        "The model predicts the probability that a transaction "
        "will be loss-making."
    )


st.markdown("""
<div style="margin-top:40px;padding:18px;text-align:center;border-top:1px solid #e2e8f0;color:#64748b;font-size:13px;">
📊 <b>Retail AI</b> • Gradient Boosting Loss Risk Predictor<br>
Built with Python • Pandas • Scikit-learn • Streamlit
</div>
""", unsafe_allow_html=True)