import "../styles/globals.css";

//INTERNAL IMPORT
import {NavBar , Footer} from "../components/comp_index";

const MyApp = ({ Component, pageProps }) => (
  <div>
      <NavBar />
      <Component {...pageProps} />
      <Footer />
  </div>
);

export default MyApp;
