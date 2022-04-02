// ---*< React/Next Imports >*-----------------------------------------
import Link from "next/link";

// ---*< Third-party Imports >*----------------------------------------
import {Menu} from "semantic-ui-react";

// ---*< Local Imports >*----------------------------------------------

// ---*< Declarations >*-----------------------------------------------

// ---*< Code >*-------------------------------------------------------

const Header = () => {
    return (
        <Menu style={{marginTop: '10px' }}>
            <Link href="/"><a className="item">Dex</a></Link>
            <Link href="/"><a className="item">Swap Eth/CD Tokens</a></Link>
            <Link href="/"><a className="item">Add Liquidity to Dex</a></Link>
            <Link href="/"><a className="item">Remove Liquidity from Dex</a></Link>
        </Menu>
    );
};

// ---*< Exports >*----------------------------------------------------
export default Header;