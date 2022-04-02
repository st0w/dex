// ---*< React/Next Imports >*-----------------------------------------

// ---*< Third-party Imports >*----------------------------------------
import {Container} from "semantic-ui-react";

// ---*< Local Imports >*----------------------------------------------
import Header from "./Header";

// ---*< Declarations >*-----------------------------------------------

// ---*< Code >*-------------------------------------------------------
const Layout = (props) => {
    return (
        <Container>
            <div>
                <Header />
                {props.children}
            </div>
        </Container>
    );
};

// ---*< Exports >*----------------------------------------------------
export default Layout;